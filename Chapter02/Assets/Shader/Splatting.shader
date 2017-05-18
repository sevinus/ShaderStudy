Shader "denoil/Splatting"
{
	Properties
	{	
		_ColorA ("ColorA (RGB)", Color) = (1, 1, 1, 1)
		_ColorB ("ColorB (RGB)", Color) = (1, 1, 1, 1)
		_SplatTex0 ("SplatTex0", 2D) = "white" {}
		_SplatTex1 ("SplatTex1", 2D) = "white" {}
		_SplatTex2 ("SplatTex2", 2D) = "white" {}
		_SplatTex3 ("SplatTex3", 2D) = "white" {}
		_BlendTex ("BlendTex", 2D) = "white" {}
	}

	SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 200

		CGPROGRAM
		#pragma surface surf Lambert
		#pragma target 3.0

		sampler2D _SplatTex0;
		sampler2D _SplatTex1;
		sampler2D _SplatTex2;
		sampler2D _SplatTex3;
		sampler2D _BlendTex;
		float4 _ColorA;
		float4 _ColorB;
		
		struct Input
		{
			float2 uv_SplatTex0;
		};
		
		void surf(Input IN, inout SurfaceOutput o)
		{
			float4 blendColor = tex2D(_BlendTex, IN.uv_SplatTex0);

			float4 splatColor0 = tex2D(_SplatTex0, IN.uv_SplatTex0);
			float4 splatColor1 = tex2D(_SplatTex1, IN.uv_SplatTex0);
			float4 splatColor2 = tex2D(_SplatTex2, IN.uv_SplatTex0);
			float4 splatColor3 = tex2D(_SplatTex3, IN.uv_SplatTex0);

			float4 finalColor = splatColor0;
			finalColor = lerp(finalColor, splatColor1, blendColor.r);
			finalColor = lerp(finalColor, splatColor2, blendColor.b);
			finalColor = lerp(finalColor, splatColor3, blendColor.a);
			
			float4 colorInterpol = lerp(_ColorA, _ColorB, blendColor.r);
			finalColor *= colorInterpol;

			finalColor = saturate(finalColor);
			o.Albedo = finalColor.rgb;
			o.Alpha = finalColor.a;
		}
		ENDCG
	}
	
	FallBack "Diffuse"
}