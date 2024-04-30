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

            typedef float4 FL4; // 取别名，方便后面使用

            #define red float4(1, 0, 0, 1); // 宏定义

            void vert(in float4 pos : POSITION, out float4 outpos : POSITION)
            {
                outpos = pos;
            }


            void frag(out float4 outcol : COLOR)
            {

                float f1 = 1.0;
                float2 f2 = float2(1, 0);
                float3 f3 = float3(1, 0, 1);
                float4 f4 = FL4(1, 0, 0, 1); // 这里使用了上面定义的别名

                // outcol = float4(1, 0, 0, 1); // red

                // outcol = float4(f1, 0, 0, 1);

                outcol = red // 使用了上面定义的宏

                // outcol = float4(f1, f2.yy, 1);


                float2x4 f2x4 = float2x4(1, 1, 0, 1, 0, 1, 0, 1); // 定义了2x4的矩阵

                outcol = f2x4[0]; // 取矩阵的第一行

            }

            ENDCG
        }
    }
}
