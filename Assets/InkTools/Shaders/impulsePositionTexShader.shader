// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Inkling/impulsePositionTexShader"
{
	Properties
		{
			fluidTex ("fluidTex", 2D) = "" {}
			colorTexMask ("colorTexMask", 2D) = "" {}

			textureData ("textureData", vector) = (0.0, 0.0, 0.0, 0.0)
		}
	SubShader {
	Pass{
		CGPROGRAM
		#pragma target 3.0
		#pragma vertex vert
		#pragma fragment frag

sampler2D fluidTex;
sampler2D colorTexMask;

float4 textureData;   //x is Position x, y is Position y, and z is color alpha

float4x4 rotationMatrix;

struct appdata
{
	float4 vertex : POSITION;
	float4 texcoord : TEXCOORD0;
};

struct v2f
{
	float4 pos : POSITION;
	float4 color : COLOR;
	float2 uv : TEXCOORD0;
};

v2f vert (appdata v)
{
	v2f o;
	o.color = float4(0, 0, 0, 1);
	o.pos = UnityObjectToClipPos( v.vertex );
	o.uv = v.texcoord.xy;
	return o;
}

		float4 frag(v2f i) : COLOR
			{
				float2 rotatedUVs = mul(rotationMatrix, i.uv.xyxy - float4((textureData.x * 2) - 0.5, (textureData.y * 2) - 0.5, 0, 0)).xy;

				return lerp(tex2D(fluidTex, i.uv), tex2D(colorTexMask, rotatedUVs + 0.5), tex2D(colorTexMask, rotatedUVs + 0.5).a * textureData.z);
			}
		ENDCG
		}
	}
}
