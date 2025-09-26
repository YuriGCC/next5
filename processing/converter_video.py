# converter video
# python conversor.py "meu_video.dav" "video_final_1920x1080.mp4"
import sys
import subprocess

def converter_video_para_widescreen(caminho_entrada, caminho_saida):
    """
    Converte um vídeo para o formato MP4 com resolução de 1920x1080,
    adicionando barras pretas (padding) para manter a proporção original.
    Ideal para converter vídeos quadrados ou verticais para o formato widescreen.

    Args:
        caminho_entrada (str): O caminho para o arquivo de vídeo de entrada (.dav, .mp4, etc.).
        caminho_saida (str): O caminho onde o arquivo .mp4 convertido será salvo.
    """
    print(f"Iniciando a conversão de '{caminho_entrada}'...")
    print(f"O vídeo de saída terá a resolução de 1920x1080.")

    # Dimensões finais do vídeo
    largura_saida = 1920
    altura_saida = 1080

    try:
        # O comando FFmpeg que faz toda a mágica.
        # -i : Define o arquivo de entrada.
        # -vf 'pad=...' : Esta é a parte chave. É um filtro de vídeo ("video filter").
        #   'pad=1920:1080:(ow-iw)/2:(oh-ih)/2:black' significa:
        #   1. Crie um quadro de 1920 de largura por 1080 de altura.
        #   2. Centralize o vídeo original nesse quadro.
        #   3. Preencha o espaço que sobrar com a cor 'black' (preto).
        # -c:v libx264 : Usa o codec de vídeo H.264, que é universalmente compatível.
        # -preset veryfast : Otimiza para uma conversão mais rápida.
        # -c:a aac : Usa o codec de áudio AAC, também muito compatível.
        comando = [
            'ffmpeg',
            '-i', caminho_entrada,
            '-vf', f'pad={largura_saida}:{altura_saida}:(ow-iw)/2:(oh-ih)/2:color=black',
            '-c:v', 'libx264',
            '-preset', 'veryfast',
            '-c:a', 'aac',
            caminho_saida
        ]

        # Executa o comando no terminal. Se o FFmpeg der um erro, o script também irá parar.
        subprocess.run(comando, check=True)

        print(f"\n✅ Conversão concluída com sucesso! O arquivo está salvo em: {caminho_saida}")

    except FileNotFoundError:
        print("\nERRO: O comando 'ffmpeg' não foi encontrado.")
        print("Certifique-se de que o FFmpeg está instalado e acessível no PATH do seu sistema.")
    except subprocess.CalledProcessError as e:
        print(f"\nERRO: O FFmpeg encontrou um problema ao processar o vídeo: {e}")
        print("Isso pode acontecer se o arquivo de vídeo de entrada estiver corrompido.")
    except Exception as e:
        print(f"\nOcorreu um erro inesperado: {e}")

# --- Ponto de Entrada do Script ---
# Esta parte só roda quando você executa 'python converter.py ...' no terminal.
if __name__ == "__main__":
    # Verifica se o usuário forneceu os 2 argumentos necessários.
    if len(sys.argv) < 3:
        print("\nErro de uso! Você precisa especificar os arquivos de entrada e saída.")
        print("Exemplo de como usar:")
        print("python converter.py \"meu_video.dav\" \"video_final_1920x1080.mp4\"")
    else:
        # Pega os nomes dos arquivos que você digitou no terminal.
        caminho_entrada_video = sys.argv[1]
        caminho_saida_video = sys.argv[2]
        
        # Chama a função principal para iniciar a conversão.
        converter_video_para_widescreen(caminho_entrada_video, caminho_saida_video)

