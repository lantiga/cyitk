#ifndef __cyitkImage_h
#define __cyitkImage_h

#include "itkImage.h"
#include "itkImageFileReader.h"
#include "itkImageFileWriter.h"

template<class TPixel, unsigned int Dim>
class cyitkImage
{
public:
  typedef TPixel PixelType;
  typedef itk::Image<PixelType,Dim> ImageType;

  cyitkImage()
  {
    m_Image = ImageType::New();
  }

  ~cyitkImage()
  {
  }

  unsigned int GetImageDimension()
  {
    return m_Image->GetImageDimension();
  }

  void GetSpacing(double* spacing)
  {
    typename ImageType::SpacingType spacingITK = m_Image->GetSpacing();
    unsigned int dimension = this->GetImageDimension();
    for (unsigned int i=0; i<dimension; i++)
      {
      spacing[i] = spacingITK[i];
      }
  }

  void SetSpacing(double* spacing)
  {
    m_Image->SetSpacing(spacing);
  }

  void GetOrigin(double* origin)
  {
    typename ImageType::PointType originITK = m_Image->GetOrigin();
    unsigned int dimension = this->GetImageDimension();
    for (unsigned int i=0; i<dimension; i++)
      {
      origin[i] = originITK[i];
      }
  }

  void SetOrigin(double* origin)
  {
    m_Image->SetOrigin(origin);
  }

  void GetDirection(double* direction)
  {
    typename ImageType::DirectionType directionITK = m_Image->GetDirection();
    unsigned int dimension = this->GetImageDimension();
    for (unsigned int i=0; i<dimension; i++)
      {
      for (unsigned int j=0; j<dimension; j++)
        {
        direction[i*dimension+j] = directionITK[i][j];
        }
      }
  }

  void SetDirection(double* direction)
  {
    typename ImageType::DirectionType directionITK;
    unsigned int dimension = this->GetImageDimension();
    for (unsigned int i=0; i<dimension; i++)
      {
      for (unsigned int j=0; j<dimension; j++)
        {
        directionITK[i][j] = direction[i*dimension+j];
        }
      }
    m_Image->SetDirection(directionITK);
  }

  void GetBufferedRegionSize(int* bufferedRegionSize)
  {
    typename ImageType::SizeType sizeITK = m_Image->GetBufferedRegion().GetSize();
    unsigned int dimension = this->GetImageDimension();
    for (unsigned int i=0; i<dimension; i++)
      {
      bufferedRegionSize[i] = sizeITK[i];
      }
  }

  void SetBufferedRegionSize(int* bufferedRegionSize)
  {
    typename ImageType::RegionType regionITK;
    typename ImageType::SizeType sizeITK;
    unsigned int dimension = this->GetImageDimension();
    for (unsigned int i=0; i<dimension; i++)
      {
      sizeITK[i] = bufferedRegionSize[i];
      }
    regionITK.SetSize(sizeITK);
    m_Image->SetBufferedRegion(regionITK);
  }

  void SetSize(int* size)
  {
    typename ImageType::RegionType regionITK;
    typename ImageType::SizeType sizeITK;
    unsigned int dimension = this->GetImageDimension();
    for (unsigned int i=0; i<dimension; i++)
      {
      sizeITK[i] = size[i];
      }
    regionITK.SetSize(sizeITK);
    m_Image->SetRegions(regionITK);
  }

  void SetITKImage(ImageType* image)
  {
    m_Image = image;
  }

  ImageType* GetITKImage()
  {
    return m_Image.GetPointer();
  }

  PixelType* GetBufferPointer()
  {
    return m_Image->GetBufferPointer();
  }

  void SetData(int* shape, PixelType* data)
  {
    unsigned int numberOfElements = 1;
    unsigned int dimension = this->GetImageDimension();
    for (unsigned int i=0; i<dimension; i++)
      {
      numberOfElements *= shape[i];
      } 
    this->SetSize(shape);
    PixelType* dataCopy = new PixelType[numberOfElements];
    memcpy(dataCopy,data,numberOfElements*sizeof(PixelType));
    m_Image->GetPixelContainer()->SetImportPointer(dataCopy,numberOfElements,true);
  }

  void ReadImage(const char* filename)
  {
    typedef itk::ImageFileReader<ImageType> ImageReaderType;
    typename ImageReaderType::Pointer reader = ImageReaderType::New();
    reader->SetFileName(filename);
    reader->Update();
  
    this->SetITKImage(reader->GetOutput());
  }

  void WriteImage(const char* filename)
  {
    typedef itk::ImageFileWriter<ImageType> ImageWriterType;
    typename ImageWriterType::Pointer writer = ImageWriterType::New();
    writer->SetFileName(filename);
    writer->SetInput(this->GetITKImage());
    writer->Update();
  }

private:
  typename ImageType::Pointer m_Image;

};

#endif
