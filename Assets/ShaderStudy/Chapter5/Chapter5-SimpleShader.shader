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

			// 定义属性变量(只有定义了才能使用)
			fixed4 _Color;

			struct a2v 
			{
				// POSITION语义告诉unity，用模型空间的顶点坐标填充vertex变量
				float4 vertex : POSITION;
				// NORMAL语义告诉unity，用模型空间的法线方向填充normal变量
				float3 normal : NORMAL;
				// TEXCOORD0语义告诉unity，用模型的第一套纹理坐标填充texcoord变量
				float4 texcoord : TEXCOORD0;
			};

			struct v2f 
			{
				// SV_POSITION语义告诉unity，pos里包含了顶点在裁剪空间中的位置信息
				float4 pos : SV_POSITION;
				// COLOR0语义可以用来存储颜色信息
				fixed3 color : COLOR0;
			};

			v2f vert(a2v v)
			{
				v2f o;
				// 计算顶点在裁剪空间中的位置
				o.pos = UnityObjectToClipPos(v.vertex);
				// v.normal包含了顶点的法线方向，其分量范围是[-1,1]
				// 下面的代码将法线方向映射到[0,1]范围，并用颜色填充v2f结构体传给片元着色器
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