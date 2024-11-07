import UIKit
import CoreImage

extension UIImage {
    var averageColor: UIColor? {
        // Crea una imagen sin transparencia con fondo blanco
        let size = CGSize(width: self.size.width, height: self.size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, self.scale)

        // Rellena el fondo de blanco
        UIColor.white.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))

        // Dibuja la imagen encima
        self.draw(at: .zero)

        // Obtén la nueva imagen sin transparencia
        let imageWithBackground = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        // Convertir la imagen a CIImage para el cálculo del color promedio
        guard let inputImage = CIImage(image: imageWithBackground!) else { return nil }

        // Define el área de cálculo
        let extentVector = CIVector(x: inputImage.extent.origin.x,
                                    y: inputImage.extent.origin.y,
                                    z: inputImage.extent.size.width,
                                    w: inputImage.extent.size.height)

        // Aplica el filtro CIAreaAverage
        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        // Procesa el color promedio en formato RGBA
        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull!])
        context.render(outputImage,
                       toBitmap: &bitmap,
                       rowBytes: 4,
                       bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
                       format: .RGBA8,
                       colorSpace: nil)

        // Crea el UIColor a partir de los valores RGBA calculados
        let red = CGFloat(bitmap[0]) / 255
        let green = CGFloat(bitmap[1]) / 255
        let blue = CGFloat(bitmap[2]) / 255

        // Incrementar la saturación para mejorar la intensidad del color
        let saturationBoost: CGFloat = 2 // Ajusta este valor para aumentar la saturación
        let maxComponent = max(red, green, blue)

        let adjustedRed = min(red * saturationBoost + (1 - saturationBoost) * maxComponent, 1.0)
        let adjustedGreen = min(green * saturationBoost + (1 - saturationBoost) * maxComponent, 1.0)
        let adjustedBlue = min(blue * saturationBoost + (1 - saturationBoost) * maxComponent, 1.0)

        return UIColor(red: adjustedRed, green: adjustedGreen, blue: adjustedBlue, alpha: 1.0)
    }
}
