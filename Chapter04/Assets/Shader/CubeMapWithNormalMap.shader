Shader "denoil/CubeMapWithNormalMap"
{
	Properties
	{
		_MainTex ("Main Tex", 2D) = "white" {}
		_NormalMapTex ("Normal Map Tex", 2D) = "white" {}
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
		sampler2D _NormalMapTex;
		samplerCUBE _CubeMapTex;
		float4 _MainTint;		
		float _ReflAmount;
				
		struct Input
		{
			float2 uv_MainTex;
			float2 uv_NormalMapTex;
			float3 worldRefl;
			INTERNAL_DATA
		};
		
		void surf(Input IN, inout SurfaceOutput o)
		{
			float4 texColor = tex2D(_MainTex, IN.uv_MainTex);

			// 노멀맵에서 노멀 추출
			float3 normal = UnpackNormal(tex2D(_NormalMapTex, IN.uv_NormalMapTex));
			
			// 로컬 노멀벡터 -> 월드 반사 벡터로 변환
			float3 worldRefl = WorldReflectionVector(IN, normal);

			// 월드 반사 벡터로 cube 맵에서 컬러 가져옴.
			float4 cubeColor = texCUBE(_CubeMapTex, worldRefl) * _ReflAmount;
			o.Albedo = texColor.rgb * _MainTint.rgb;
			o.Emission = cubeColor;			
			o.Alpha = 1.0f;	
			o.Normal = normal;
		}
		ENDCG
	}
	
	FallBack "Diffuse"
}