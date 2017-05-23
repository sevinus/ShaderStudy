Shader "denoil/CubeMap"
{
	Properties
	{
		_MainTex ("Main Tex", 2D) = "white" {}
		_CubeMapTex ("CubeMap Tex", CUBE) = "" {}
		_MainTint ("Main Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_ReflAmount ("Reflection Amoult", Range(0.01, 1)) = 0.5
		
	}

	SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 200

		CGPROGRAM
		#include "Lighting.cginc"

		#pragma surface surf Lambert

		sampler2D _MainTex;
		samplerCUBE _CubeMapTex;
		float4 _MainTint;		
		float _ReflAmount;
				
		struct Input
		{
			float2 uv_MainTex;
			float3 worldRefl;
		};
		
		void surf(Input IN, inout SurfaceOutput o)
		{
			float4 texColor = tex2D(_MainTex, IN.uv_MainTex);
			float3 cubeColor = texCUBE(_CubeMapTex, IN.worldRefl).rgb * _ReflAmount;
			o.Albedo = texColor.rgb * _MainTint.rgb;
			o.Emission = cubeColor;
			o.Alpha = 1.0f;			
			o.Gloss = 1.0f;
		}
		ENDCG
	}
	
	FallBack "Diffuse"
}