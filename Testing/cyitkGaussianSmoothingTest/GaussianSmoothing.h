#ifndef __GaussianSmoothing_h
#define __GaussianSmoothing_h

#include "itkImage.h"
#include "itkRecursiveGaussianImageFilter.h"

namespace itk {

typedef Image<float,2> ImageType;

void GaussianSmoothing(ImageType* inputImage, ImageType* outputImage, double sigma)
{
  typedef RecursiveGaussianImageFilter<ImageType> RecursiveGaussianFilterType;

  RecursiveGaussianFilterType::Pointer gaussianFilter = RecursiveGaussianFilterType::New();
  gaussianFilter->SetInput(inputImage);
  gaussianFilter->SetSigma(sigma);
  gaussianFilter->Update();

  outputImage->Graft(gaussianFilter->GetOutput());
}

}

#endif
