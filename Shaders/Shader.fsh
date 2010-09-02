//
//  Shader.fsh
//  OpenGLes
//
//  Created by Enes Battal on 8/9/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
