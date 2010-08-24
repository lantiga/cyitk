import cyitkGaussianSmoothingTest as cyitk

a = cyitk.ReadImageF2('input.nrrd')
b = cyitk.ImageF2()
cyitk.GaussianSmoothing(a,b,1.0)

import pylab

fig = pylab.figure(1)
fig.subplots_adjust(bottom=0.05, left=0.05, top=0.95, right=0.95, wspace=0.1, hspace=0.1)

subplot = pylab.subplot(1,2,1)
subplot.set_title('input.nrrd')
pylab.imshow(a.GetArray())
pylab.gray()

subplot = pylab.subplot(1,2,2)
subplot.set_title('output.mha')
pylab.imshow(b.GetArray())
pylab.gray()

print a.GetArray()
print b.GetArray()

fig.savefig('figure.png')
pylab.show()

b.WriteImage('output.mha')

