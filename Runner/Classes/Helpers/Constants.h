/*
 *  Constants.h
 *  PhysicsBox2d
 *
 *  Created by Steffen Itterheim on 20.09.10.
 *  Copyright 2010 Steffen Itterheim. All rights reserved.
 *
 *  Enhanced to use PhysicsEditor shapes and retina display
 *  by Andreas Loew / http://www.physicseditor.de
 *
 */

#include "GB2ShapeCache.h"

// Pixel to metres ratio. Box2D uses metres as the unit for measurement.
// This ratio defines how many pixels correspond to 1 Box2D "metre"
// Box2D is optimized for objects of 1x1 metre therefore it makes sense
// to define the ratio so that your most common object type is 1x1 metre.
// We use the value set in PhysicsEditor.
// The value must be divided by 2.0 (multiplied with 0.5) because the shapes 
// we used to create the polygons are in highres (Retina display) and 
// cocos2d always uses lowres "points"
#define PTM_RATIO ([[GB2ShapeCache sharedShapeCache] ptmRatio] * 0.50f)
