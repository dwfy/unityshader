Shader "Study/Test/CGInOutTest"
{
    SubShader
    {
        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            void vert(in float2 posobj:POSITION, out float4 pos:POSITION, out float4 color:COLOR) 
            {
                pos = float4(posobj,0,1);
                color = pos;
            }
                
            void frag(in float4 pos:POSITION, inout float4 color:COLOR)
            {
                // color = float4(0,1,0,1);
            }

            ENDCG
        }
    }
}