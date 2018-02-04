Shader "Unlit/FragShine"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
    _ShineTex ("Shine", 2D) = "white" {}
    _Speed("Speed", float) = 0.5
	}
	SubShader
	{
		Tags { "RenderType"="Transparent" }
		LOD 100

		Pass
		{
      Blend SrcAlpha OneMinusSrcAlpha
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
        float2 uv_shine : TEXCOORD1;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
        float2 uv_shine : TEXCOORD1;
				float4 vertex : SV_POSITION;
			};

			sampler2D_half _MainTex, _ShineTex;
      half4 _MainTex_ST;
      half4 _ShineTex_ST;
      float _Speed;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
        o.uv_shine = TRANSFORM_TEX(v.uv_shine, _ShineTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
        i.uv_shine.x += _Time.x * _Speed;

        fixed4 result;

				fixed4 main = tex2D(_MainTex, i.uv);
        fixed4 shine = tex2D(_ShineTex, i.uv_shine);

        result.rgb = main.rgb * (1 - shine.a) + shine.rgb * shine.a;
        result.a = main.a + shine.a;
				return result;
			}
			ENDCG
		}
	}
}
