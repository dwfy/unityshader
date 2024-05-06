// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "UnityShaderBook/Chapter5/FlaseColor"{
	SubShader{
		Pass{
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct v2f{
				float4 pos : SV_POSITION;
				fixed4 col : COLOR0;
			};

			v2f vert(appdata_full v){
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				// ���߷�����ӻ�
				// o.col = fixed4(v.normal * 0.5 + fixed3(0.5, 0.5, 0.5), 1.0);
				// o.col = fixed4(1, 0.5, 0.5, 1);
				// ���߷�����ӻ�
				o.col = fixed4(v.tangent * 0.5 + fixed3(0.5, 0.5, 0.5), 1);

				// o.col = fixed4(1,0.5,0.5,1);

				// // �����߷�����ӻ�
				// fixed4 binormal = cross(v.normal, v.tangent.xyz)  * v.tangent.w;
				// o.col = fixed4(binormal * 0.5 + fixed3(0.5, 0.5, 0.5), 1);
				// // ��һ������������ӻ�
				// o.col = fixed4(v.texcoord.xy, 0, 1);
				// // �ڶ�������������ӻ�
				// o.col = fixed4(v.texcoord1.xy, 0, 1);
				// // ���ӻ���һ����������С������
				// o.col = frac(v.texcoord);
				// if(any(saturat(v.texcoord) - v.vexcoord)){
				// 	o.col.b = 0.5;
				// }

				// o.col.a = 1;

				// ���ӻ��ڶ�����������С������
				// o.col = frac(v.texcoord1);
				// if(any(saturat(v.texcoord1) - v.texcoord1)){
				// 	o.col.b = 0.5;
				// }

				// o.col.a = 1;

				// ���ӻ�������ɫ
				// o.col = v.color;

				return o;
			}

			fixed4 frag(v2f i) : SV_Target{
				return i.col;
			}

			ENDCG
		}
	}
}