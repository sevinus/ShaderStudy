Shader "denoil/BlinnPhong"
{
	Properties
	{
		_MainTex ("Main Tex", 2D) = "white" {}
		_MainTint ("Main Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_SpecColor ("Specular Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_SpecPower ("Specular Power", float) = 1.0
	}

	SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 200

		CGPROGRAM
		#include "Lighting.cginc"

		#pragma surface surf BlinnPhong 

		float4 _MainTint;
		float _SpecPower;
				
		struct Input
		{
			float2 uv_MainTex;
		};
		
		void surf(Input IN, inout SurfaceOutput o)
		{
			o.Albedo = _MainTint.xyz;
			o.Alpha = 1.0f;			
			o.Specular = _SpecPower;
			o.Gloss = 1.0f;
		}
		ENDCG
	}
	
	FallBack "Diffuse"
}