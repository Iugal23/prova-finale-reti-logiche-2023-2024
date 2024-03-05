-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb is
end project_tb;

architecture project_tb_arch of project_tb is
    constant CLOCK_PERIOD : time := 20 ns;
    signal tb_clk : std_logic := '0';
    signal tb_rst, tb_start, tb_done : std_logic;
    signal tb_add : std_logic_vector(15 downto 0);
    signal tb_k   : std_logic_vector(9 downto 0);

    signal tb_o_mem_addr, exc_o_mem_addr, init_o_mem_addr : std_logic_vector(15 downto 0);
    signal tb_o_mem_data, exc_o_mem_data, init_o_mem_data : std_logic_vector(7 downto 0);
    signal tb_i_mem_data : std_logic_vector(7 downto 0);
    signal tb_o_mem_we, tb_o_mem_en, exc_o_mem_we, exc_o_mem_en, init_o_mem_we, init_o_mem_en : std_logic;

    type ram_type is array (65535 downto 0) of std_logic_vector(7 downto 0);
    signal RAM : ram_type := (OTHERS => "00000000");

constant SCENARIO_LENGTH : integer := 602;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,0,0,47,0,202,0,0,0,244,0,0,0,168,0,254,0,244,0,125,0,200,0,1,0,193,0,0,0,106,0,239,0,144,0,123,0,0,0,122,0,68,0,0,0,0,0,172,0,46,0,51,0,0,0,0,0,206,0,141,0,176,0,86,0,82,0,222,0,212,0,175,0,184,0,167,0,47,0,203,0,0,0,97,0,136,0,86,0,164,0,0,0,0,0,151,0,144,0,47,0,205,0,104,0,115,0,0,0,207,0,222,0,0,0,0,0,0,0,86,0,150,0,170,0,0,0,167,0,95,0,83,0,148,0,255,0,87,0,0,0,0,0,241,0,63,0,84,0,102,0,0,0,0,0,137,0,0,0,18,0,0,0,223,0,0,0,30,0,94,0,34,0,245,0,63,0,216,0,39,0,178,0,0,0,0,0,0,0,255,0,188,0,141,0,0,0,55,0,161,0,164,0,54,0,0,0,236,0,137,0,0,0,219,0,210,0,191,0,62,0,151,0,3,0,206,0,0,0,98,0,227,0,0,0,121,0,0,0,222,0,0,0,106,0,230,0,133,0,213,0,121,0,102,0,64,0,199,0,84,0,112,0,171,0,0,0,102,0,211,0,164,0,121,0,127,0,202,0,0,0,22,0,0,0,0,0,211,0,134,0,108,0,0,0,141,0,90,0,120,0,194,0,0,0,125,0,88,0,0,0,92,0,135,0,94,0,57,0,179,0,64,0,249,0,99,0,187,0,87,0,187,0,231,0,244,0,244,0,143,0,67,0,114,0,214,0,20,0,84,0,51,0,82,0,231,0,0,0,133,0,55,0,56,0,0,0,244,0,51,0,201,0,36,0,83,0,86,0,135,0,168,0,0,0,18,0,165,0,177,0,239,0,170,0,124,0,58,0,61,0,158,0,0,0,134,0,65,0,180,0,224,0,24,0,90,0,46,0,0,0,193,0,47,0,179,0,0,0,244,0,18,0,163,0,100,0,32,0,71,0,202,0,215,0,0,0,128,0,42,0,0,0,252,0,142,0,126,0,227,0,197,0,224,0,214,0,95,0,0,0,145,0,186,0,152,0,208,0,4,0,63,0,0,0,60,0,71,0,0,0,126,0,38,0,34,0,59,0,195,0,0,0,32,0,100,0,87,0,138,0,178,0,73,0,30,0,5,0,124,0,43,0,141,0,78,0,80,0,73,0,169,0,48,0,0,0,47,0,251,0,246,0,0,0,82,0,217,0,55,0,126,0,6,0,0,0,172,0,220,0,120,0,135,0,184,0,112,0,106,0,0,0,180,0,0,0,0,0,0,0,11,0,63,0,80,0,0,0,43,0,0,0,36,0,108,0,0,0,246,0,172,0,73,0,68,0,98,0,223,0,206,0,65,0,158,0,52,0,29,0,148,0,87,0,36,0,21,0,249,0,111,0,115,0,58,0,246,0,113,0,98,0,240,0,0,0,11,0,28,0,167,0,0,0,0,0,110,0,162,0,62,0,38,0,56,0,201,0,247,0,136,0,134,0,21,0,57,0,147,0,0,0,118,0,59,0,0,0,44,0,166,0,127,0,229,0,248,0,195,0,90,0,129,0,39,0,116,0,237,0,206,0,58,0,95,0,148,0,0,0,231,0,195,0,211,0,0,0,152,0,163,0,18,0,0,0,18,0,0,0,205,0,11,0,0,0,0,0,35,0,148,0,199,0,0,0,92,0,0,0,0,0,163,0,88,0,31,0,93,0,37,0,0,0,148,0,36,0,2,0,1,0,0,0,144,0,118,0,186,0,0,0,0,0,0,0,42,0,51,0,80,0,1,0,0,0,51,0,236,0,135,0,51,0,25,0,45,0,0,0,182,0,135,0,237,0,184,0,178,0,0,0,74,0,32,0,173,0,0,0,179,0,213,0,248,0,24,0,0,0,92,0,172,0,191,0,250,0,83,0,46,0,0,0,138,0,169,0,134,0,93,0,0,0,95,0,77,0,211,0,62,0,211,0,87,0,0,0,0,0,0,0,129,0,0,0,0,0,0,0,211,0,80,0,46,0,0,0,29,0,9,0,147,0,0,0,0,0,86,0,29,0,0,0,105,0,200,0,0,0,0,0,230,0,0,0,57,0,220,0,243,0,16,0,56,0,72,0,211,0,103,0,17,0,29,0,240,0,0,0,4,0,154,0,168,0,53,0,59,0,252,0,145,0,193,0,183,0,71,0,148,0,214,0,226,0,0,0,117,0,0,0,25,0,181,0,0,0,144,0,238,0,251,0,0,0,247,0,81,0,156,0,0,0,0,0,137,0,74,0,214,0,61,0,35,0,135,0,0,0,25,0,140,0,48,0,56,0,175,0,197,0,134,0,0,0,8,0,24,0,0,0,0,0,129,0,253,0,2,0,67,0,210,0,224,0,137,0,87,0,201,0,172,0,148,0,0,0,97,0,197,0,133,0,58,0,188,0,186,0,39,0,2,0,0,0,0,0,220,0,163,0,225,0,0,0,0,0,152,0,183,0,104,0,87,0,140,0,0,0,6,0,71,0,20,0,127,0,176,0,114,0,209,0,76,0,250,0,0,0,85,0,0,0,118,0,0,0,23,0,181,0,130,0,147,0,85,0,26,0,0,0,66,0,69,0,68,0,94,0,132,0,58,0,0,0,0,0,28,0,114,0,110,0,203,0,97,0,0,0,44,0,197,0,181,0,227,0,55,0,96,0);
signal scenario_full  : scenario_type := (0,0,0,0,47,31,202,31,202,30,244,31,244,30,168,31,254,31,244,31,125,31,200,31,1,31,193,31,193,30,106,31,239,31,144,31,123,31,123,30,122,31,68,31,68,30,68,29,172,31,46,31,51,31,51,30,51,29,206,31,141,31,176,31,86,31,82,31,222,31,212,31,175,31,184,31,167,31,47,31,203,31,203,30,97,31,136,31,86,31,164,31,164,30,164,29,151,31,144,31,47,31,205,31,104,31,115,31,115,30,207,31,222,31,222,30,222,29,222,28,86,31,150,31,170,31,170,30,167,31,95,31,83,31,148,31,255,31,87,31,87,30,87,29,241,31,63,31,84,31,102,31,102,30,102,29,137,31,137,30,18,31,18,30,223,31,223,30,30,31,94,31,34,31,245,31,63,31,216,31,39,31,178,31,178,30,178,29,178,28,255,31,188,31,141,31,141,30,55,31,161,31,164,31,54,31,54,30,236,31,137,31,137,30,219,31,210,31,191,31,62,31,151,31,3,31,206,31,206,30,98,31,227,31,227,30,121,31,121,30,222,31,222,30,106,31,230,31,133,31,213,31,121,31,102,31,64,31,199,31,84,31,112,31,171,31,171,30,102,31,211,31,164,31,121,31,127,31,202,31,202,30,22,31,22,30,22,29,211,31,134,31,108,31,108,30,141,31,90,31,120,31,194,31,194,30,125,31,88,31,88,30,92,31,135,31,94,31,57,31,179,31,64,31,249,31,99,31,187,31,87,31,187,31,231,31,244,31,244,31,143,31,67,31,114,31,214,31,20,31,84,31,51,31,82,31,231,31,231,30,133,31,55,31,56,31,56,30,244,31,51,31,201,31,36,31,83,31,86,31,135,31,168,31,168,30,18,31,165,31,177,31,239,31,170,31,124,31,58,31,61,31,158,31,158,30,134,31,65,31,180,31,224,31,24,31,90,31,46,31,46,30,193,31,47,31,179,31,179,30,244,31,18,31,163,31,100,31,32,31,71,31,202,31,215,31,215,30,128,31,42,31,42,30,252,31,142,31,126,31,227,31,197,31,224,31,214,31,95,31,95,30,145,31,186,31,152,31,208,31,4,31,63,31,63,30,60,31,71,31,71,30,126,31,38,31,34,31,59,31,195,31,195,30,32,31,100,31,87,31,138,31,178,31,73,31,30,31,5,31,124,31,43,31,141,31,78,31,80,31,73,31,169,31,48,31,48,30,47,31,251,31,246,31,246,30,82,31,217,31,55,31,126,31,6,31,6,30,172,31,220,31,120,31,135,31,184,31,112,31,106,31,106,30,180,31,180,30,180,29,180,28,11,31,63,31,80,31,80,30,43,31,43,30,36,31,108,31,108,30,246,31,172,31,73,31,68,31,98,31,223,31,206,31,65,31,158,31,52,31,29,31,148,31,87,31,36,31,21,31,249,31,111,31,115,31,58,31,246,31,113,31,98,31,240,31,240,30,11,31,28,31,167,31,167,30,167,29,110,31,162,31,62,31,38,31,56,31,201,31,247,31,136,31,134,31,21,31,57,31,147,31,147,30,118,31,59,31,59,30,44,31,166,31,127,31,229,31,248,31,195,31,90,31,129,31,39,31,116,31,237,31,206,31,58,31,95,31,148,31,148,30,231,31,195,31,211,31,211,30,152,31,163,31,18,31,18,30,18,31,18,30,205,31,11,31,11,30,11,29,35,31,148,31,199,31,199,30,92,31,92,30,92,29,163,31,88,31,31,31,93,31,37,31,37,30,148,31,36,31,2,31,1,31,1,30,144,31,118,31,186,31,186,30,186,29,186,28,42,31,51,31,80,31,1,31,1,30,51,31,236,31,135,31,51,31,25,31,45,31,45,30,182,31,135,31,237,31,184,31,178,31,178,30,74,31,32,31,173,31,173,30,179,31,213,31,248,31,24,31,24,30,92,31,172,31,191,31,250,31,83,31,46,31,46,30,138,31,169,31,134,31,93,31,93,30,95,31,77,31,211,31,62,31,211,31,87,31,87,30,87,29,87,28,129,31,129,30,129,29,129,28,211,31,80,31,46,31,46,30,29,31,9,31,147,31,147,30,147,29,86,31,29,31,29,30,105,31,200,31,200,30,200,29,230,31,230,30,57,31,220,31,243,31,16,31,56,31,72,31,211,31,103,31,17,31,29,31,240,31,240,30,4,31,154,31,168,31,53,31,59,31,252,31,145,31,193,31,183,31,71,31,148,31,214,31,226,31,226,30,117,31,117,30,25,31,181,31,181,30,144,31,238,31,251,31,251,30,247,31,81,31,156,31,156,30,156,29,137,31,74,31,214,31,61,31,35,31,135,31,135,30,25,31,140,31,48,31,56,31,175,31,197,31,134,31,134,30,8,31,24,31,24,30,24,29,129,31,253,31,2,31,67,31,210,31,224,31,137,31,87,31,201,31,172,31,148,31,148,30,97,31,197,31,133,31,58,31,188,31,186,31,39,31,2,31,2,30,2,29,220,31,163,31,225,31,225,30,225,29,152,31,183,31,104,31,87,31,140,31,140,30,6,31,71,31,20,31,127,31,176,31,114,31,209,31,76,31,250,31,250,30,85,31,85,30,118,31,118,30,23,31,181,31,130,31,147,31,85,31,26,31,26,30,66,31,69,31,68,31,94,31,132,31,58,31,58,30,58,29,28,31,114,31,110,31,203,31,97,31,97,30,44,31,197,31,181,31,227,31,55,31,96,31);

    signal memory_control : std_logic := '0';
    
    constant SCENARIO_ADDRESS : integer := 1234;

    component project_reti_logiche is
        port (
                i_clk : in std_logic;
                i_rst : in std_logic;
                i_start : in std_logic;
                i_add : in std_logic_vector(15 downto 0);
                i_k   : in std_logic_vector(9 downto 0);
                
                o_done : out std_logic;
                
                o_mem_addr : out std_logic_vector(15 downto 0);
                i_mem_data : in  std_logic_vector(7 downto 0);
                o_mem_data : out std_logic_vector(7 downto 0);
                o_mem_we   : out std_logic;
                o_mem_en   : out std_logic
        );
    end component project_reti_logiche;

begin
    UUT : project_reti_logiche
    port map(
                i_clk   => tb_clk,
                i_rst   => tb_rst,
                i_start => tb_start,
                i_add   => tb_add,
                i_k     => tb_k,
                
                o_done => tb_done,
                
                o_mem_addr => exc_o_mem_addr,
                i_mem_data => tb_i_mem_data,
                o_mem_data => exc_o_mem_data,
                o_mem_we   => exc_o_mem_we,
                o_mem_en   => exc_o_mem_en
    );

    -- Clock generation
    tb_clk <= not tb_clk after CLOCK_PERIOD/2;

    -- Process related to the memory
    MEM : process (tb_clk)
    begin
        if tb_clk'event and tb_clk = '1' then
            if tb_o_mem_en = '1' then
                if tb_o_mem_we = '1' then
                    RAM(to_integer(unsigned(tb_o_mem_addr))) <= tb_o_mem_data after 1 ns;
                    tb_i_mem_data <= tb_o_mem_data after 1 ns;
                else
                    tb_i_mem_data <= RAM(to_integer(unsigned(tb_o_mem_addr))) after 1 ns;
                end if;
            end if;
        end if;
    end process;
    
    memory_signal_swapper : process(memory_control, init_o_mem_addr, init_o_mem_data,
                                    init_o_mem_en,  init_o_mem_we,   exc_o_mem_addr,
                                    exc_o_mem_data, exc_o_mem_en, exc_o_mem_we)
    begin
        -- This is necessary for the testbench to work: we swap the memory
        -- signals from the component to the testbench when needed.
    
        tb_o_mem_addr <= init_o_mem_addr;
        tb_o_mem_data <= init_o_mem_data;
        tb_o_mem_en   <= init_o_mem_en;
        tb_o_mem_we   <= init_o_mem_we;

        if memory_control = '1' then
            tb_o_mem_addr <= exc_o_mem_addr;
            tb_o_mem_data <= exc_o_mem_data;
            tb_o_mem_en   <= exc_o_mem_en;
            tb_o_mem_we   <= exc_o_mem_we;
        end if;
    end process;
    
    -- This process provides the correct scenario on the signal controlled by the TB
    create_scenario : process
    begin
        wait for 50 ns;

        -- Signal initialization and reset of the component
        tb_start <= '0';
        tb_add <= (others=>'0');
        tb_k   <= (others=>'0');
        tb_rst <= '1';
        
        -- Wait some time for the component to reset...
        wait for 50 ns;
        
        tb_rst <= '0';
        memory_control <= '0';  -- Memory controlled by the testbench
        
        wait until falling_edge(tb_clk); -- Skew the testbench transitions with respect to the clock

        -- Configure the memory        
        for i in 0 to SCENARIO_LENGTH*2-1 loop
            init_o_mem_addr<= std_logic_vector(to_unsigned(SCENARIO_ADDRESS+i, 16));
            init_o_mem_data<= std_logic_vector(to_unsigned(scenario_input(i),8));
            init_o_mem_en  <= '1';
            init_o_mem_we  <= '1';
            wait until rising_edge(tb_clk);   
        end loop;
        
        wait until falling_edge(tb_clk);

        memory_control <= '1';  -- Memory controlled by the component
        
        tb_add <= std_logic_vector(to_unsigned(SCENARIO_ADDRESS, 16));
        tb_k   <= std_logic_vector(to_unsigned(SCENARIO_LENGTH, 10));
        
        tb_start <= '1';

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        wait for 5 ns;
        
        tb_start <= '0';
        
        wait;
        
    end process;

    -- Process without sensitivity list designed to test the actual component.
    test_routine : process
    begin

        wait until tb_rst = '1';
        wait for 25 ns;
        assert tb_done = '0' report "TEST FALLITO o_done !=0 during reset" severity failure;
        wait until tb_rst = '0';

        wait until falling_edge(tb_clk);
        assert tb_done = '0' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        
        wait until rising_edge(tb_start);

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        assert tb_o_mem_en = '0' or tb_o_mem_we = '0' report "TEST FALLITO o_mem_en !=0 memory should not be written after done." severity failure;

        for i in 0 to SCENARIO_LENGTH*2-1 loop
            assert RAM(SCENARIO_ADDRESS+i) = std_logic_vector(to_unsigned(scenario_full(i),8)) report "TEST FALLITO @ OFFSET=" & integer'image(i) & " expected= " & integer'image(scenario_full(i)) & " actual=" & integer'image(to_integer(unsigned(RAM(i)))) severity failure;
        end loop;

        wait until falling_edge(tb_start);
        assert tb_done = '1' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        wait until falling_edge(tb_done);

        assert false report "Simulation Ended! TEST PASSATO (EXAMPLE)" severity failure;
    end process;

end architecture;
