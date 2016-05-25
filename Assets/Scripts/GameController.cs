using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
using System.Collections;

public class GameController : MonoBehaviour
{
  public GameObject hazard;
  public Vector3 spawnValues;
  public int hazardCount;
  public float spawnWait;
  public float startWait;
  public float waveWait;

  public Text scoreText;
  public Text restartText;
  public Text gameOverText;

  private int score;
  private bool restart;
  private bool gameOver;

  void Start()
  {
    UpdateScore(0);
    ToggleRestart(false);
    ToggleGameOver(false);

    StartCoroutine(SpawnWaves());
  }
  void Update()
  {
    if (restart && Input.GetKeyDown(KeyCode.R))
    {
      SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex);
    }
  }

  public void AddScore(int scoreValue)
  {
    UpdateScore(score + scoreValue);
  }

  public void GameOver()
  {
    ToggleGameOver(true);
  }

  private IEnumerator SpawnWaves()
  {
    yield return new WaitForSeconds(startWait);

    while (true)
    {
      for (int i = 0; i < hazardCount; i++)
      {
        Vector3 spawnPosition = new Vector3(Random.Range(-spawnValues.x, spawnValues.x), spawnValues.y, spawnValues.z);
        Quaternion spawnRotation = Quaternion.identity;
        Instantiate(hazard, spawnPosition, spawnRotation);
        yield return new WaitForSeconds(spawnWait);
      }

      yield return new WaitForSeconds(waveWait);

      if (gameOver)
      {
        ToggleRestart(true);
        break;
      }
    }
  }

  private void UpdateScore(int newScore)
  {
    score = newScore;
    scoreText.text = "Score: " + score;
  }
  public void ToggleRestart(bool show)
  {
    restart = show;
    restartText.text = restart ? "Press 'R' to Restart" : "";
  }

  public void ToggleGameOver(bool show)
  {
    gameOver = show;
    gameOverText.text = gameOver ? "Game Over" : "";
  }
}
