Shader "denoil/NormalMap"
{
	Properties
	{
		_MainTex ("MainTex", 2D) = "white" {}
		_NormalMapTex ("NormalMapTex", 2D) = "bump" {}
		_NormalIntensity ("Normal Intensity", Range(0, 2)) = 1
	}

	SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 200

		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;
		sampler2D _NormalMapTex;
		float _NormalIntensity;
		
		struct Input
		{
			float2 uv_MainTex;
			float2 uv_NormalMapTex;
		};
		
		void surf(Input IN, inout SurfaceOutput o)
		{
			float4 color = tex2D(_MainTex, IN.uv_MainTex);			
			float2 normalUV = IN.uv_NormalMapTex;
			float4 normalColor = tex2D(_NormalMapTex, IN.uv_NormalMapTex);					
			float3 normalMap = UnpackNormal(normalColor).rgb;
			normalMap = float3(normalMap.x * _NormalIntensity, normalMap.y * _NormalIntensity, normalMap.z);

			o.Albedo = color.rgb;
			o.Alpha = color.a;
			o.Normal = normalMap;
		}
		ENDCG
	}
	
	FallBack "Diffuse"
}