<?php

function toCamelCase($string) {
    $result = strtolower($string);
    preg_match_all('/_[a-z]/', $result, $matches);
    foreach ($matches[0] as $match) {
        $c = str_replace('_', '', strtoupper($match));
        $result = str_replace($match, $c, $result);
    }
    return $result;
}

function convertVariablesToCamelCase($content) {
    // Expresión regular para encontrar las variables de PHP
    $pattern = '/\$([^_]\w+_\w+)/';
    return preg_replace_callback($pattern, function ($matches) {
        return '$' . toCamelCase($matches[1]);
    }, $content);
}

function processDirectory($directory) {
    $iterator = new RecursiveIteratorIterator(new RecursiveDirectoryIterator($directory));
    foreach ($iterator as $file) {
        if ($file->isFile() && pathinfo($file, PATHINFO_EXTENSION) === 'php') {
            $filePath = $file->getRealPath();
            $fileContent = file_get_contents($filePath);

            if ($fileContent === false) {
                echo "Error al leer el archivo: $filePath\n";
                continue;
            }

            $updatedContent = convertVariablesToCamelCase($fileContent);

            $result = file_put_contents($filePath, $updatedContent);

            if ($result === false) {
                echo "Error al escribir en el archivo: $filePath\n";
            } else {
                echo "Variables convertidas a camelCase en: $filePath\n";
            }
        }
    }
}

// Verificar si se proporcionó un argumento de línea de comandos
if ($argc < 2) {
  die("Error: Debes proporcionar una ruta al directorio.\nUso: php script.php ruta/al/directorio\n");
}

$relativeDirectory = $argv[1]; // Ruta proporcionada como argumento de línea de comandos
$absoluteDirectory = realpath($relativeDirectory);

if ($absoluteDirectory === false) {
  die("Error: La ruta proporcionada no es válida.\n");
}

processDirectory($absoluteDirectory);


?>