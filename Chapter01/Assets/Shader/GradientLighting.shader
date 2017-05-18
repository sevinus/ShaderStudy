Shader "denoil/GradientLight"
{
	Properties
	{
		_MainTex ("Main Tex", 2D) = "white" {}
		_RampTex ("Ramp Tex", 2D) = "white" {}
		_LightColor ("Light Color", Color) = (1, 1, 1, 1)
	}

	SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 200

		CGPROGRAM
		#pragma surface surf HalfLambertLighting

		sampler2D _MainTex;
		sampler2D _RampTex;
		float4 _LightColor;
				
		inline float4 LightingHalfLambertLighting(SurfaceOutput s, fixed3 lightDir, fixed atten)
		{
			float dotLight = max(0, dot(s.Normal, lightDir));
			float halfLambert = dotLight * 0.5f + 0.5f;
			float3 ramp = tex2D(_RampTex, float2(halfLambert, halfLambert)).rgb;

			float4 color;
			color.rgb = s.Albedo * _LightColor * ramp;
			color.a = s.Alpha;
			return color;
		}
		
		struct Input
		{
			float2 uv_MainTex;
		};
		
		void surf(Input IN, inout SurfaceOutput o)
		{
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
			
			o.Albedo = c.rgb;
			o.Alpha = c.a;			
		}
		ENDCG
	}
	
	FallBack "Diffuse"
}