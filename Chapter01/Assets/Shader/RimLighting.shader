Shader "denoil/RimLighting"
{
	Properties
	{
		_LightColor ("Light Color", Color) = (1, 1, 1, 1)
		_RimPower ("RimPower", Range(0.1, 3)) = 1
	}

	SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 200

		CGPROGRAM
		#pragma surface surf RimLighting

		float4 _LightColor;
		fixed _RimPower;
				
		inline float4 LightingRimLighting(SurfaceOutput s, fixed3 lightDir, fixed3 viewDir, fixed atten)
		{
			float dotLight = max(0, dot(s.Normal, lightDir));
			float rim = saturate(dot(s.Normal, viewDir));
			rim = pow(rim, _RimPower);

			float4 color;
			color.rgb = s.Albedo * _LightColor * rim;
			color.a = s.Alpha;
			return color;
		}
		
		struct Input
		{
			float2 uv_MainTex;
		};
		
		void surf(Input IN, inout SurfaceOutput o)
		{
			fixed4 c = fixed4(1, 1, 1, 1);
			
			o.Albedo = c.rgb;
			o.Alpha = c.a;			
		}
		ENDCG
	}
	
	FallBack "Diffuse"
}