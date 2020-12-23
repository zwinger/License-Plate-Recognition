# License-Plate-Recognition

Final Project for CPE 428

This project was designed to identify license plates in an image and predict what the license plate numbers are.

When given an image, all the potential areas in the image where a license plate may be are found and cropped out of the image. Each cropped segment is then used to predict what the license plate number may be. If there is no license plate in the cropped segment, the segment is discarded.

All calculations are done using traditional computer vision techniques. The detection of license plate uses edge maps and custom heuristics to predict what areas of an image may contain a license plate. To predict the license palte number, techniques such as SIFT and template matching are used.