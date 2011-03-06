cimport cyitk
import cyitk


cdef extern from "GaussianSmoothing.h":

    void itkGaussianSmoothingF2 "GaussianSmoothingF2" (cyitk.itkImageF2* inputImage, cyitk.itkImageF2* outputImage, double sigma) except +

def GaussianSmoothingF2 (inputImage,outputImage,sigma):

    itkGaussianSmoothingF2((<cyitk.ImageF2>inputImage).GetITKImage(), (<cyitk.ImageF2>outputImage).GetITKImage(),sigma)


cdef extern from "GaussianSmoothing.h":

    void itkGaussianSmoothingD2 "GaussianSmoothingD2" (cyitk.itkImageD2* inputImage, cyitk.itkImageD2* outputImage, double sigma) except +

def GaussianSmoothingD2 (inputImage,outputImage,sigma):

    itkGaussianSmoothingD2((<cyitk.ImageD2>inputImage).GetITKImage(), (<cyitk.ImageD2>outputImage).GetITKImage(),sigma)


