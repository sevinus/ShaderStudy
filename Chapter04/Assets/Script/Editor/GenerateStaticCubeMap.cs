using UnityEngine;
using UnityEditor;
using System.Collections;

public class GenerateStaticCubeMap : ScriptableWizard {

    public Transform m_renderPosition;
    public Cubemap m_cubeMap;
	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
	
	}

    void OnWizardUpdate()
    {
        helpString = "Select transform to render" +
            "from and cubemap to render into";

        if (m_renderPosition != null && m_cubeMap != null)
            isValid = true;
        else
            isValid = false;
    }

    void OnWizardCreate()
    {
        GameObject go = new GameObject("CubeCam", typeof(Camera));

        go.transform.position = m_renderPosition.position;
        go.transform.rotation = Quaternion.identity;

        Camera camera = go.GetComponent<Camera>();
        camera.RenderToCubemap(m_cubeMap);

        DestroyImmediate(go);
    }

    [MenuItem("denoil/Render CubeMap")]
    static void RenderCubeMap()
    {
        ScriptableWizard.DisplayWizard("Render CubeMap", typeof(GenerateStaticCubeMap), "Renderer!");
    }
}
