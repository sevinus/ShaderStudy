Shader "denoil/Phong"
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

		#pragma surface surf Phong

		float4 _MainTint;
		float _SpecPower;

		inline fixed4 LightingPhong(SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
		{
			float diffuse = dot(s.Normal, lightDir);

			//half3 reflectionVector = 2 * s.Normal * diffuse - lightDir;
			//float spec = max(0, dot(viewDir, reflectionVector));
			
			// reflect(입사각, 노멀벡터);
			half3 reflectionVector = reflect(-lightDir, s.Normal);
			float spec = max(0, dot(viewDir, reflectionVector));
			
			spec = pow(spec, _SpecPower * 128.0f) * s.Gloss;
			
			fixed4 diffuseColor;
			fixed4 specularColor;
			fixed4 finalColor;

			diffuseColor.rgb = s.Albedo * diffuse;
			specularColor = _SpecColor * spec;

			finalColor.rgb = diffuseColor.rgb + specularColor.rgb;
			finalColor.a = 1.0f;

			return finalColor;		
		}
		
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