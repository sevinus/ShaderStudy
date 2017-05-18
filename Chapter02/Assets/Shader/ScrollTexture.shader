Shader "denoil/ScrollTexture"
{
	Properties
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_ScrollXSpeed ("Scroll X", Range(0, 10)) = 2
		_ScrollYSpeed ("Scroll Y", Range(0, 10)) = 2
	}

	SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 200

		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;
		float _ScrollXSpeed;
		float _ScrollYSpeed;
		
		struct Input
		{
			float2 uv_MainTex;
		};
		
		void surf(Input IN, inout SurfaceOutput o)
		{
			float2 texUV = IN.uv_MainTex;
			float xValue = _ScrollXSpeed * _Time;
			float yValue = _ScrollYSpeed * _Time;

			texUV.x += xValue;

			float4 c = tex2D(_MainTex, texUV);			
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
	
	FallBack "Diffuse"
}