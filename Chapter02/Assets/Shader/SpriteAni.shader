Shader "denoil/SpriteAni"
{
	Properties
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_SpriteCount ("Sprite Count", float) = 0
		_AniSpeed ("Ani Speed", float) = 1
	}

	SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 200

		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;
		float _SpriteCount;
		float _AniSpeed;
		
		struct Input
		{
			float2 uv_MainTex;
		};
		
		void surf(Input IN, inout SurfaceOutput o)
		{
			float2 texUV = IN.uv_MainTex;
			
			float coordRate = 1.0f / _SpriteCount;

			float frame = fmod(_Time.y * _AniSpeed, _SpriteCount);
			frame = ceil(frame);			
			texUV.x *= coordRate;
			texUV.x += coordRate * frame;
			

			float4 c = tex2D(_MainTex, texUV);	
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
	
	FallBack "Diffuse"
}