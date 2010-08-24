#ifndef __GaussianSmoothing_h
#define __GaussianSmoothing_h

#include "itkImage.h"
#include "itkRecursiveGaussianImageFilter.h"

namespace itk {

typedef Image<float,2> ImageTypeA;

//@cyitk void GaussianSmoothingF2(@ImageF2 inputImage, @ImageF2 outputImage, double sigma)
void GaussianSmoothingF2(ImageTypeA* inputImage, ImageTypeA* outputImage, double sigma)
{
  typedef RecursiveGaussianImageFilter<ImageTypeA> RecursiveGaussianFilterType;

  RecursiveGaussianFilterType::Pointer gaussianFilter = RecursiveGaussianFilterType::New();
  gaussianFilter->SetInput(inputImage);
  gaussianFilter->SetSigma(sigma);
  gaussianFilter->Update();

  outputImage->Graft(gaussianFilter->GetOutput());
}

typedef Image<double,2> ImageTypeB;

//@cyitk void GaussianSmoothingD2(@ImageD2 inputImage, @ImageD2 outputImage, double sigma)
void GaussianSmoothingD2(ImageTypeB* inputImage, ImageTypeB* outputImage, double sigma)
{
  typedef RecursiveGaussianImageFilter<ImageTypeB> RecursiveGaussianFilterType;

  RecursiveGaussianFilterType::Pointer gaussianFilter = RecursiveGaussianFilterType::New();
  gaussianFilter->SetInput(inputImage);
  gaussianFilter->SetSigma(sigma);
  gaussianFilter->Update();

  outputImage->Graft(gaussianFilter->GetOutput());
}


}

#endif
