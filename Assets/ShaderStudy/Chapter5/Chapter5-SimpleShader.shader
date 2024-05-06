// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "UnityShaderBook/Chapter5/SimpleShader"
{
	Properties
	{
		_Color("Color Tint", Color) = (1,1,1,1)
	}

	SubShader
	{
		Pass
		{

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			// �������Ա���(ֻ�ж����˲���ʹ��)
			fixed4 _Color;

			struct a2v 
			{
				// POSITION�������unity����ģ�Ϳռ�Ķ����������vertex����
				float4 vertex : POSITION;
				// NORMAL�������unity����ģ�Ϳռ�ķ��߷������normal����
				float3 normal : NORMAL;
				// TEXCOORD0�������unity����ģ�͵ĵ�һ�������������texcoord����
				float4 texcoord : TEXCOORD0;
			};

			struct v2f 
			{
				// SV_POSITION�������unity��pos������˶����ڲü��ռ��е�λ����Ϣ
				float4 pos : SV_POSITION;
				// COLOR0������������洢��ɫ��Ϣ
				fixed3 color : COLOR0;
			};

			v2f vert(a2v v)
			{
				v2f o;
				// ���㶥���ڲü��ռ��е�λ��
				o.pos = UnityObjectToClipPos(v.vertex);
				// v.normal�����˶���ķ��߷����������Χ��[-1,1]
				// ����Ĵ��뽫���߷���ӳ�䵽[0,1]��Χ��������ɫ���v2f�ṹ�崫��ƬԪ��ɫ��
				o.color = v.normal * 0.5 + fixed3(0.5, 0.5, 0.5);
				return o;
			}

			fixed4 frag(v2f i) : SV_TARGET 
			{
				fixed3 color = i.color;
				color *= _Color.rgb;
				return fixed4(color, 1);
			}

			ENDCG
		}
	}
}