// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "UnityShaderBook/Chapter6/DiffusePixelLevel"{
	Properties{
		_Diffuse("Diffuse", Color) = (1,1,1,1)
	}

	SubShader{
		Pass{

			Tags{"LightMode" = "ForwardBase"}

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "Lighting.cginc"

			fixed4 _Diffuse;

			struct a2v{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};
			
			struct v2f{
				float4 pos : SV_POSITION;
				float3 worldNormal : TEXCOORD0;
			};

			v2f vert(a2v v){
				v2f o;
				// MVP
				o.pos = UnityObjectToClipPos(v.vertex);
				// 模型空间法线变换到世界空间
				o.worldNormal = mul(v.normal, (float3x3)unity_WorldToObject);

				return o;
			}

			// 实现逐片元的漫反射光照
			fixed4 frag(v2f i) : SV_Target{

				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

				fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * max(0, dot(i.worldNormal, normalize(_WorldSpaceLightPos0.xyz)));

				fixed3 color = ambient + diffuse;

				return fixed4(color, 1);
			}

			ENDCG
		}
	}
	Fallback "Diffuse"
}