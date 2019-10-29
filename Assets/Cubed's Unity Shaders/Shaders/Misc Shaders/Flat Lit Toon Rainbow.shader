Shader "CubedParadox/Flat Lit Toon Rainbow" {
    Properties {
        _MainTex ("MainTex", 2D) = "white" {}
        _ColorMask ("ColorMask", 2D) = "black" {}
        _Saturation ("Saturation", Float ) = 0
        _Value ("Value", Float ) = 0
        _Speed ("Speed", Float ) = 0
    }
    SubShader {
        Tags {
            "RenderType"="Opaque"
        }
        
        CGPROGRAM
        #pragma surface surf Lambert addshadow
        struct Input {
            float4 color : COLOR;
        };
        void surf(Input IN, inout SurfaceOutput o) {
            o.Albedo = 1;
        }
        ENDCG
        
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
            #include "AutoLight.cginc"
            #include "Lighting.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma multi_compile_fog
            #pragma exclude_renderers gles3 metal d3d11_9x xbox360 xboxone ps3 ps4 psp2 
            #pragma target 3.0
            uniform float4 _TimeEditor;
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            float3 CubemapReflections( float3 reflVect ){
            float4 val = UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, reflVect, 7);
            float3 reflCol = DecodeHDR(val, unity_SpecCube0_HDR);
            return reflCol * 0.02;
            }
            
            float3 Function_node_3693( float3 normal ){
            return ShadeSH9(half4(normal, 1.0));
            
            }
            
            uniform sampler2D _ColorMask; uniform float4 _ColorMask_ST;
            uniform float _Saturation;
            uniform float _Value;
            uniform float _Speed;

            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                LIGHTING_COORDS(1,2)
                UNITY_FOG_COORDS(3)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                float4 objPos = mul ( unity_ObjectToWorld, float4(0,0,0,1) );
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos(v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                float4 objPos = mul ( unity_ObjectToWorld, float4(0,0,0,1) );
                float3 lightColor = _LightColor0.rgb;
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(i.uv0, _MainTex));
                float4 node_1939 = (_Time * _Speed) + _TimeEditor;
                float4 _ColorMask_var = tex2D(_ColorMask,TRANSFORM_TEX(i.uv0, _ColorMask));
                float3 finalColor = (lerp((_MainTex_var.rgb*(lerp(float3(1,1,1),saturate(3.0*abs(1.0-2.0*frac(node_1939.r+float3(0.0,-1.0/3.0,1.0/3.0)))-1),_Saturation)*_Value)),_MainTex_var.rgb,_ColorMask_var.r)*saturate((Function_node_3693( float3(0,1,0) )+CubemapReflections( normalize((_WorldSpaceCameraPos-objPos.rgb)) )+(_LightColor0.rgb*attenuation))));
                fixed4 finalRGBA = fixed4(finalColor,1);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
        Pass {
            Name "FORWARD_DELTA"
            Tags {
                "LightMode"="ForwardAdd"
            }
            Blend One One
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
			#ifndef UNITY_PASS_FORWARDADD
				#define UNITY_PASS_FORWARDADD
			#endif
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #include "Lighting.cginc"
            #pragma multi_compile_fwdadd_fullshadows
            #pragma multi_compile_fog
            #pragma exclude_renderers gles3 metal d3d11_9x xbox360 xboxone ps3 ps4 psp2 
            #pragma target 3.0
            uniform float4 _TimeEditor;
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            float3 CubemapReflections( float3 reflVect ){
            float4 val = UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, reflVect, 7);
            float3 reflCol = DecodeHDR(val, unity_SpecCube0_HDR);
            return reflCol * 0.02;
            }
            
            float3 Function_node_3693( float3 normal ){
            return ShadeSH9(half4(normal, 1.0));
            
            }
            
            uniform sampler2D _ColorMask; uniform float4 _ColorMask_ST;
            uniform float _Saturation;
            uniform float _Value;
            uniform float _Speed;

            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                LIGHTING_COORDS(1,2)
                UNITY_FOG_COORDS(3)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                float4 objPos = mul ( unity_ObjectToWorld, float4(0,0,0,1) );
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos(v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                float4 objPos = mul ( unity_ObjectToWorld, float4(0,0,0,1) );
                float3 lightColor = _LightColor0.rgb;
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(i.uv0, _MainTex));
                float4 node_1939 = (_Time * _Speed) + _TimeEditor;
                float4 _ColorMask_var = tex2D(_ColorMask,TRANSFORM_TEX(i.uv0, _ColorMask));
                float3 finalColor = (lerp((_MainTex_var.rgb*(lerp(float3(1,1,1),saturate(3.0*abs(1.0-2.0*frac(node_1939.r+float3(0.0,-1.0/3.0,1.0/3.0)))-1),_Saturation)*_Value)),_MainTex_var.rgb,_ColorMask_var.r)*saturate((Function_node_3693( float3(0,1,0) )+CubemapReflections( normalize((_WorldSpaceCameraPos-objPos.rgb)) )+(_LightColor0.rgb*attenuation))));
                fixed4 finalRGBA = fixed4(finalColor * 1,0);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
