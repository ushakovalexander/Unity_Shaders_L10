  Shader "Unlit/Jelly"
  {
    Properties
    {
      _MainTex ("Texture", 2D) = "white" {}
      _Speed ("Speed", float) = 1
      _Amount ("Amount", float) = 5
      _Distance ("Disatnce", float) = 0.1
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
        };

        struct v2f
        {
          float2 uv : TEXCOORD0;
          float4 vertex : SV_POSITION;
        };

        sampler2D _MainTex;
        float4 _MainTex_ST;
        float _Speed;
        float _Amount;
        float _Distance;
        
        v2f vert (appdata v)
        {
          v2f o;

          half offsetVert = sin(_Time.y * v.vertex.y);
          half offsetHor = sin( _Time.y * _Speed + offsetVert * _Amount ) * _Distance;
          v.vertex.x += offsetHor;
          v.vertex.y += offsetHor;
         
          o.vertex = UnityObjectToClipPos(v.vertex);
          o.uv = TRANSFORM_TEX(v.uv, _MainTex);
          UNITY_TRANSFER_FOG(o,o.vertex);
          return o;
        }
        
        fixed4 frag (v2f i) : SV_Target
        {
          fixed4 col = tex2D(_MainTex, i.uv);
          return col;
        }
        ENDCG
      }
    }
  }
