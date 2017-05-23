Shader "denoil/FresnelCubeMap"
{
	Properties
	{
		_MainTex ("Main Tex", 2D) = "white" {}
		_CubeMapTex ("CubeMap Tex", CUBE) = "" {}
		_MainTint ("Main Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_ReflAmount ("Reflection Amount", Range(0.01, 1)) = 0.5
		_RimPower ("Fresnel Falloff", Range(0.1, 3)) = 2
		_SpecPower ("Specular Power", Range(0, 1)) = 0.5
		
	}

	SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 200

		CGPROGRAM
		#include "Lighting.cginc"

		#pragma surface surf Lambert

		sampler2D _MainTex;
		samplerCUBE _CubeMapTex;
		float4 _MainTint;		
		float _ReflAmount;
		float _RimPower;
		float _SpecPower;
				
		struct Input
		{
			float2 uv_MainTex;
			float3 worldRefl;
			float3 viewDir;
		};

		fixed4 LightingUnlit(SurfaceOutput s, fixed3 lightDir, fixed ateen)		
		{
			fixed4 color = fixed4(1.0f, 1.0f, 1.0f, 1.0f);
			color.rgb = color * s.Albedo;
			color.a = s.Alpha;

			return color;
		}
		
		void surf(Input IN, inout SurfaceOutput o)
		{
			float4 texColor = tex2D(_MainTex, IN.uv_MainTex);
			float rim = 1.0f - saturate(dot(o.Normal, IN.viewDir));
			rim = pow(rim, _RimPower);

			float3 cubeColor = (texCUBE(_CubeMapTex, IN.worldRefl).rgb * _ReflAmount) * rim;
			o.Albedo = texColor.rgb * _MainTint.rgb;
			o.Emission = cubeColor;
			o.Alpha = 1.0f;			
			o.Gloss = 1.0f;
			o.Specular = _SpecPower;
		}
		ENDCG
	}
	
	FallBack "Diffuse"
}