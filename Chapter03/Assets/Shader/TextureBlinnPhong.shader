Shader "denoil/TextureBlinnPhong"
{
	Properties
	{
		_MainTex ("Main Tex", 2D) = "white" {}
		_SpecularMap ("SpecularMap", 2D) = "white" {}
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

		#pragma surface surf TextureBlinnPhong 

		sampler2D _MainTex;
		sampler2D _SpecularMap;
		float4 _MainTint;
		float _SpecPower;
				
		inline fixed4 LightingTextureBlinnPhong(SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
		{
			float3 halfVector = normalize(lightDir + viewDir);
			float diffuse = dot(s.Normal, lightDir);

			float spec = max(0, dot(s.Normal, halfVector));
			spec = pow(spec, _SpecPower * 128.0f) * s.Gloss * s.Specular;

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
			float4 texColor = tex2D(_MainTex, IN.uv_MainTex);
			float4 specMapColor = tex2D(_SpecularMap, IN.uv_MainTex);
			o.Albedo = texColor.rgb * _MainTint.rgb;
			o.Alpha = 1.0f;			
			o.Specular = specMapColor.r;
			o.Gloss = 1.0f;
		}
		ENDCG
	}
	
	FallBack "Diffuse"
}