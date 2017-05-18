Shader "denoil/ImageProcess"
{
	Properties
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_InBlack ("InBlack", Range(0, 255)) = 0
		_InGamma ("InGamma", Range(0, 2)) = 1.61
		_InWhite ("InWhite", Range(0, 255)) = 255

		_OutWhite ("OutWhite", Range(0, 255)) = 255
		_OutBlack ("OutBlack", Range(0, 255)) = 0
	}

	SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 200

		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;
		float _InBlack;
		float _InWhite;
		float _InGamma;

		float _OutWhite;
		float _OutBlack;
		
		struct Input
		{
			float2 uv_MainTex;
		};

		float GetPixelLevel(float pixelColor)
		{
			float resultColor = pixelColor * 255.0f;
			resultColor = max(0, resultColor - _InBlack);
			resultColor = saturate(pow(resultColor / (_InWhite - _InBlack), _InGamma));
			resultColor = (resultColor * (_OutWhite - _OutBlack) + _OutBlack) / 255.0f;

			return resultColor;
		}
		
		void surf(Input IN, inout SurfaceOutput o)
		{
			float2 texUV = IN.uv_MainTex;
			float4 c = tex2D(_MainTex, texUV);
			
			float r = GetPixelLevel(c.x);
			float g = GetPixelLevel(c.y);
			float b = GetPixelLevel(c.z );

			o.Albedo = float4(r, g, b, 1.0f);
			o.Alpha = c.a;
		}
		ENDCG
	}
	
	FallBack "Diffuse"
}