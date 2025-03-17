// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "UnityShaderBook/Chapter7/NormalMapInTangentSpace"
{

	Properties {
		_Color("Color Tint", Color) = (1,1,1,1)
		_MainTex("Main Tex", 2D) = "White" {}
		_BumpMap("Normal Map", 2D) = "bump" {}  // unity内置的法线纹理，当没有提供任何法线纹理时，就对应了模型自带的法线信息
		_BumpScale("Bump Scale", Float) = 1.0	// 用于控制凹凸程度，当它为0时，意味着该法线纹理不会对光照产生任何影响
		_Specular("Specular", Color) = (1,1,1,1)
		_Gloss("Gloss", Range(8.0, 256)) = 20
	}

	SubShader{
	
		Pass{
		
			Tags { "LightMode" = "ForwardBase" }

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#include "Lighting.cginc"

			fixed4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _BumpMap;
			float4 _BumpMap_ST;
			float _BumpScale;
			fixed4 _Specular;
			float _Gloss;

			struct a2v {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float4 texcoord : TEXCOORD0;
			};


			struct v2f {
				float4 pos : SV_POSITION;
				float4 uv : TEXCOORD0;
				float3 lightDir : TEXCOORD1;
				float3 viewDir : TEXCOORD2;
			};


			v2f vert(a2v v) {
				
				v2f o;
				// 将顶点位置变换到裁剪空间
				o.pos = UnityObjectToClipPos(v.vertex);

				// 计算主纹理和法线贴图的UV坐标，应用各自的缩放和偏移。
				o.uv.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				o.uv.zw = v.texcoord.xy * _BumpMap_ST.xy + _BumpMap_ST.zw;

				// 使用TANGENT_SPACE_ROTATION宏构建从模型空间到切线空间的旋转矩阵。
				TANGENT_SPACE_ROTATION;

				// 将光照方向和视角方向从模型空间转换到切线空间，并传递给片段着色器。
				o.lightDir = mul(rotation, ObjSpaceLightDir(v.vertex)).xyz;

				o.viewDir = mul(rotation, ObjSpaceViewDir(v.vertex)).xyz;
			
				return o;
			}

			fixed4 frag(v2f i) :SV_Target {
			
				fixed3 tangentLightDir = normalize(i.lightDir);
				fixed3 tangentViewDir = normalize(i.viewDir);

				// 从法线贴图采样并解压得到切线空间法线。
				fixed4 packedNormal = tex2D(_BumpMap, i.uv.zw);
				fixed3 tangentNormal;

				tangentNormal = UnpackNormal(packedNormal);
				// 使用_BumpScale调整法线贴图的XY分量，重新计算Z分量以保持法线归一化。
				tangentNormal.xy *= _BumpScale;
				tangentNormal.z = sqrt(1.0 - saturate(dot(tangentNormal.xy, tangentNormal.xy)));

				// 结合环境光颜色和表面颜色。
				fixed3 albedo = tex2D(_MainTex, i.uv).rgb * _Color.rgb;

				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;

				// 基于切线空间法线和光照方向的点积计算漫反射分量。
				fixed3 diffuse = _LightColor0.rgb * albedo * max(0, dot(tangentNormal, tangentLightDir));

				// 使用Blinn-Phong模型，计算半角向量与法线的点积，结合光泽度得到高光强度。
				fixed3 halfDir = normalize(tangentLightDir + tangentViewDir);
				fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0, dot(tangentNormal, halfDir)), _Gloss);

				// 将环境光、漫反射和高光相加，得到最终像素颜色。
				return fixed4(ambient + diffuse + specular, 1.0);
			}


			ENDCG


		}

	}

	FallBack "Specular"
}