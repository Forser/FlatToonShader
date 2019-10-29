using UnityEngine;
using UnityEngine.SceneManagement;
using System.Collections;

namespace UnityChan
{
	[ExecuteInEditMode]
	public class SplashScreen : MonoBehaviour
	{
		void NextLevel ()
		{
            SceneManager.LoadScene(0);
			//Application.LoadLevel (Application.loadedLevel + 1);
		}
	}
}