Shader "Study/Test/CGCtrlTest"
{
    SubShader
    {
        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            void vert(in float4 objpos : POSITION, out float4 pos:POSITION, out float4 col : COLOR)
            {
                pos = objpos;
                // if (pos.x < 0)
                // {
                //     col = float4(1, 0, 0, 1);
                // }
                // else
                // {
                //     col = float4(0, 1, 0, 1);
                // }

                if (pos.x < 0 && pos.y < 0)
                {
                    col = float4(1, 0, 0, 1);
                }
                else if (pos.x < 0)
                {
                    col  = float4(0, 1, 0, 1);
                }
                else if (pos.y < 0)
                {
                    col = float4(0, 0, 1, 1);
                }
                else
                {
                    col = float4(1, 1, 1, 1);
                }
                    
            }
            void frag(in float4 pos : POSITION, inout float4 col : COLOR)
            {
                
            }

            ENDCG
        }

            
    }
}
