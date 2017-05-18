Shader "denoil/BasicLighting"
{
	Properties
	{
		_LightColor ("Light Color", Color) = (1, 1, 1, 1)
	}

	SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 200

		CGPROGRAM
		#pragma surface surf BasicLighting		

		float4 _LightColor;
				
		inline float4 LightingBasicLighting(SurfaceOutput s, fixed3 lightDir, fixed atten)
		{
			float dotLight = max(0, dot(s.Normal, lightDir));

			float4 color;
			color.rgb = s.Albedo * _LightColor * (dotLight * atten * 2);
			color.a = s.Alpha;
			return color;
		}
		
		struct Input
		{
			float2 uv_MainTex;
		};
		
		void surf(Input IN, inout SurfaceOutput o)
		{
			fixed4 c = fixed4(1, 1, 1, 1);
			
			o.Albedo = c.rgb;
			o.Alpha = c.a;			
		}
		ENDCG
	}
	
	FallBack "Diffuse"
}