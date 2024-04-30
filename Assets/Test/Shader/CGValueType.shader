Shader "Study/Test/CGValueType"
{
    SubShader
    {
        pass
        {

            CGPROGRAM
// Upgrade NOTE: excluded shader from OpenGL ES 2.0 because it uses non-square matrices
#pragma exclude_renderers gles
            #pragma vertex vert
            #pragma fragment frag

            typedef float4 FL4; // ȡ�������������ʹ��

            #define red float4(1, 0, 0, 1); // �궨��

            void vert(in float4 pos : POSITION, out float4 outpos : POSITION)
            {
                outpos = pos;
            }


            void frag(out float4 outcol : COLOR)
            {

                float f1 = 1.0;
                float2 f2 = float2(1, 0);
                float3 f3 = float3(1, 0, 1);
                float4 f4 = FL4(1, 0, 0, 1); // ����ʹ�������涨��ı���

                // outcol = float4(1, 0, 0, 1); // red

                // outcol = float4(f1, 0, 0, 1);

                outcol = red // ʹ�������涨��ĺ�

                // outcol = float4(f1, f2.yy, 1);


                float2x4 f2x4 = float2x4(1, 1, 0, 1, 0, 1, 0, 1); // ������2x4�ľ���

                outcol = f2x4[0]; // ȡ����ĵ�һ��

            }

            ENDCG
        }
    }
}
