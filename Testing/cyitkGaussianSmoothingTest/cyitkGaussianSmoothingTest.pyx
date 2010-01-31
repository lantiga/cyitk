cimport cyitk
import cyitk
 
cdef extern from "GaussianSmoothing.h":
    void itkGaussianSmoothing "itk::GaussianSmoothing"(cyitk.itkImageF2* inputImage, cyitk.itkImageF2* outputImage, double sigma) except +

def GaussianSmoothing(inputImage,outputImage,sigma):
    itkGaussianSmoothing((<cyitk.ImageF2>inputImage).GetITKImage(),(<cyitk.ImageF2>outputImage).GetITKImage(),sigma)

