Shader "denoil/Water"
{
	Properties
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_NormalTex ("Noraml (RGB)", 2D) = "white" {}
		_WaterSpeed ("Water Speed", float) = 0.1
	}

	SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 200

		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;
		sampler2D _NormalTex;
		float _WaterSpeed;
		
		struct Input
		{
			float2 uv_MainTex;
		};
		
		void surf(Input IN, inout SurfaceOutput o)
		{
			float2 normalUV = IN.uv_MainTex;
			normalUV.x += _Time.y * _WaterSpeed;
			float4 normal = tex2D(_NormalTex, normalUV);

			float2 texUV = IN.uv_MainTex;
			texUV.xy += normal.xy;

			float4 c = tex2D(_MainTex, texUV);			
			o.Albedo = c.rgb;
			o.Alpha = 1.0;
		}
		ENDCG
	}
	
	FallBack "Diffuse"
}