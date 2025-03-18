// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "UnityShaderBook/Chapter7/MaskTexture"
{
	Properties{
		_Color("ColorTint", Color) = (1,1,1,1)
		_MainTex("MainTex", 2D) = "white" {}
		_BumpMap("NormalMap", 2D) = "bump" {}
		_BumpScale("BumpScale", Float) = 1.0
		_SpecularMask("SpecularMask", 2D) = "white" {}
		_SpecularScale("SpecularScale", Float) = 1.0
		_Specular("Specular", Color) = (1,1,1,1)
		_Gloss("Gloss", Range(8.0, 256)) = 20
	}


	SubShader{
	
		Pass{
		
			Tags {"LightMode" = "ForwardBase"}

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "Lighting.cginc"

			fixed4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _BumpMap;
			float _BumpScale;
			sampler2D _SpecularMask;
			float _SpecularScale;
			fixed4 _Specular;
			float _Gloss;


			struct a2v {
			
				float4 vertex : POSITION;
				float3 normal :NORMAL;
				float4 tangent : TANGENT;
				float4 texcoord : TEXCOORD0;

			};

			struct v2f {
			
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				float3 lightDir : TEXCOORD1;
				float3 viewDir : TEXCOORD2;

			};


			v2f vert(a2v v) {
			
				v2f o;

				o.pos = UnityObjectToClipPos(v.vertex);

				o.uv.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;

				TANGENT_SPACE_ROTATION;

				o.lightDir = mul(rotation, ObjSpaceLightDir(v.vertex)).xyz;
				o.viewDir = mul(rotation, ObjSpaceViewDir(v.vertex)).xyz;

				return o;
			
			}

			fixed4 frag(v2f i) : SV_Target {
				// 对切线空间的光照方向和视角方向进行归一化。
				fixed3 tangentLightDir = normalize(i.lightDir);
				fixed3 tangentViewDir = normalize(i.viewDir);

				// 使用法线贴图获取切线空间法线，调整法线的xy分量（乘以_BumpScale），然后重新计算z分量，确保法线是单位向量。
				fixed3 tangentNormal = UnpackNormal(tex2D(_BumpMap, i.uv));
				tangentNormal.xy *= _BumpScale;
				tangentNormal.z = sqrt(1.0 - saturate(dot(tangentNormal.xy, tangentNormal.xy)));

				// 采样主纹理，结合颜色色调得到albedo（漫反射颜色）。
				fixed3 albedo = tex2D(_MainTex, i.uv).rgb * _Color.rgb;
				// 环境光计算：环境光颜色乘以albedo。
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;
				// 漫反射计算：使用兰伯特模型，计算法线和光照方向的点积，乘以光颜色和albedo。
				fixed3 diffuse = _LightColor0.rgb * albedo * max(0, dot(tangentNormal, tangentLightDir));
				// 计算半角向量（Blinn-Phong模型）
				fixed3 halfDir = normalize(tangentLightDir + tangentViewDir);
				// 采样高光遮罩纹理的红色通道，乘以_SpecularScale，得到高光遮罩值specularMask。
				fixed specularMask = tex2D(_SpecularMask, i.uv).r * _SpecularScale;
				// 计算高光反射：光颜色、高光颜色、法线与半角的点积的幂次方，乘以高光遮罩值。
				fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0, dot(tangentNormal, halfDir)), _Gloss) * specularMask;

				return fixed4(ambient + diffuse + specular, 1.0);
			
			}

			ENDCG

		}

	}

	FallBack "Specular"

}