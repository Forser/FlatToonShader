Shader "CubedParadox/Simple Gradient Sky" {
    Properties {
        _SkyColor ("Sky Color", Color) = (0.197,0.197,0.197,1)
        _HorizonColor ("Horizon Color", Color) = (0.4980392,0.4980392,0.4980392,1)
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Background"
            "RenderType"="Opaque"
            "PreviewType"="Skybox"
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
			#ifndef UNITY_PASS_FORWARDBASE
				#define UNITY_PASS_FORWARDBASE
			#endif
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma only_renderers d3d9 d3d11 glcore gles n3ds wiiu 
            #pragma target 3.0
            uniform float4 _SkyColor;
            uniform float4 _HorizonColor;
            float3 dither( float2 p ){
            float3 p3 = frac(float3(p.xyx) * (float3(443.8975,397.2973, 491.1871) + _Time.y));
            p3 += dot(p3, p3.yxz + 19.19);
            return (frac(float3((p3.x + p3.y)*p3.z, (p3.x + p3.z)*p3.y, (p3.y + p3.z)*p3.x)) - 0.5) * 2 * 0.00075;
            }
            
            struct VertexInput {
                float4 vertex : POSITION;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float4 posWorld : TEXCOORD0;
                float4 projPos : TEXCOORD1;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos( v.vertex );
                o.projPos = ComputeScreenPos (o.pos);
                COMPUTE_EYEDEPTH(o.projPos.z);
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float2 sceneUVs = (i.projPos.xy / i.projPos.w);
////// Lighting:
////// Emissive:
                float3 emissive = (dither( sceneUVs.rg )+lerp(_SkyColor.rgb,_HorizonColor.rgb,pow((1.0 - max(0,dot(viewDirection,float3(0,-1,0)))),8.0)));
                float3 finalColor = emissive;
                return fixed4(finalColor,1);
            }
            ENDCG
        }
    }
}
