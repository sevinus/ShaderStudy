using UnityEngine;
using System.Collections;

public class ProceduralTexture : MonoBehaviour {

    int m_widthHeight = 512;
    Texture2D m_generateTexture;

    Material m_curMaterial;
    Vector2 m_centerPos;

	// Use this for initialization
	void Start () {

        if (m_curMaterial == null)
        {
            Renderer renderer = gameObject.GetComponent<Renderer>();
            m_curMaterial = renderer.sharedMaterial;
        }

        m_centerPos = new Vector2(0.5f, 0.5f);
        m_generateTexture = GenerateParabola();

        m_curMaterial.SetTexture("_MainTex", m_generateTexture);
	}
	
	// Update is called once per frame
	void Update () {
	
	}

    Texture2D GenerateParabola()     
    {
        Texture2D proceduralTexture = new Texture2D(m_widthHeight, m_widthHeight, TextureFormat.RGBA32, false);        
        Vector2 centerPos = m_centerPos * m_widthHeight;
        float radius = m_widthHeight * 0.5f;

        for (int x = 0; x < m_widthHeight; ++x)
        {
            for (int y = 0; y < m_widthHeight; ++y)
            {
                Vector2 curPos = new Vector2(x, y);
                float dist = Vector2.Distance(centerPos, curPos); 
                dist /= radius;
                dist = Mathf.Clamp(dist, 0, 1.0f);
                dist = 1.0f - dist;

                Color pixelColor = new Color(dist, dist, dist, 1.0f);
                proceduralTexture.SetPixel(x, y, pixelColor);
            }
        }

        proceduralTexture.Apply();
        return proceduralTexture;
    }
}
