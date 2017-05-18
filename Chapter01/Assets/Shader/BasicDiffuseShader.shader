﻿Shader "denoil/BasicDiffuse"
{
	Properties
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_EmissiveColor ("Emmisive Color", Color) = (1, 1, 1, 1)
		_AmbientColor ("Ambient Color", Color) = (1, 1, 1, 1)
		_MySliderValue ("This is a Slider", Range(0, 10)) = 2.5
	}

	SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 200

		CGPROGRAM
		#pragma surface surf Lambert
		#pragma target 3.0

		sampler2D _MainTex;
		float4 _EmissiveColor;
		float4 _AmbientColor;
		float _MySliderValue;
		
		struct Input
		{
			float2 uv_MainTex;
		};
		
		void surf(Input IN, inout SurfaceOutput o)
		{
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
			c = c * _EmissiveColor;
			
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
	
	FallBack "Diffuse"
}