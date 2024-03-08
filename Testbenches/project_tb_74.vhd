-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_74 is
end project_tb_74;

architecture project_tb_arch_74 of project_tb_74 is
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

constant SCENARIO_LENGTH : integer := 494;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (121,0,45,0,134,0,84,0,238,0,0,0,0,0,2,0,124,0,65,0,0,0,124,0,147,0,0,0,251,0,216,0,128,0,120,0,112,0,143,0,155,0,217,0,210,0,0,0,28,0,38,0,14,0,122,0,179,0,30,0,186,0,0,0,57,0,0,0,186,0,0,0,100,0,112,0,255,0,0,0,0,0,2,0,179,0,0,0,197,0,216,0,0,0,110,0,0,0,202,0,105,0,42,0,38,0,235,0,82,0,211,0,0,0,48,0,160,0,105,0,221,0,26,0,193,0,221,0,105,0,114,0,241,0,0,0,24,0,187,0,195,0,35,0,158,0,90,0,0,0,100,0,86,0,10,0,85,0,73,0,197,0,0,0,184,0,38,0,129,0,241,0,88,0,62,0,70,0,0,0,0,0,0,0,107,0,31,0,57,0,14,0,143,0,0,0,62,0,90,0,152,0,81,0,177,0,250,0,111,0,0,0,135,0,80,0,87,0,216,0,177,0,114,0,210,0,178,0,123,0,224,0,0,0,204,0,0,0,131,0,33,0,51,0,192,0,154,0,245,0,0,0,0,0,229,0,81,0,4,0,0,0,211,0,70,0,88,0,0,0,5,0,13,0,0,0,131,0,162,0,210,0,0,0,0,0,229,0,0,0,0,0,83,0,136,0,0,0,204,0,123,0,125,0,217,0,164,0,54,0,161,0,0,0,237,0,201,0,31,0,0,0,0,0,60,0,13,0,77,0,0,0,166,0,190,0,39,0,226,0,135,0,63,0,248,0,0,0,32,0,0,0,233,0,187,0,251,0,20,0,0,0,0,0,140,0,144,0,182,0,188,0,103,0,159,0,0,0,5,0,186,0,133,0,19,0,105,0,10,0,254,0,54,0,145,0,168,0,7,0,103,0,111,0,0,0,219,0,50,0,33,0,185,0,141,0,93,0,136,0,0,0,205,0,76,0,0,0,228,0,0,0,118,0,28,0,36,0,161,0,79,0,0,0,214,0,170,0,67,0,0,0,8,0,235,0,205,0,168,0,3,0,44,0,68,0,126,0,116,0,10,0,80,0,76,0,44,0,161,0,206,0,78,0,253,0,72,0,69,0,215,0,249,0,191,0,94,0,108,0,237,0,110,0,187,0,86,0,69,0,139,0,118,0,0,0,131,0,56,0,90,0,90,0,47,0,230,0,188,0,132,0,51,0,0,0,55,0,70,0,94,0,194,0,0,0,129,0,156,0,0,0,203,0,203,0,69,0,5,0,40,0,0,0,205,0,0,0,147,0,0,0,211,0,47,0,58,0,249,0,106,0,222,0,0,0,116,0,229,0,32,0,0,0,150,0,0,0,243,0,164,0,114,0,15,0,232,0,199,0,59,0,36,0,51,0,129,0,196,0,25,0,245,0,102,0,235,0,0,0,92,0,0,0,83,0,24,0,0,0,0,0,210,0,74,0,198,0,0,0,154,0,62,0,240,0,102,0,0,0,205,0,15,0,0,0,0,0,170,0,33,0,220,0,70,0,0,0,230,0,41,0,102,0,215,0,0,0,143,0,12,0,80,0,16,0,0,0,97,0,100,0,142,0,203,0,0,0,86,0,233,0,137,0,0,0,212,0,0,0,96,0,66,0,159,0,29,0,130,0,130,0,127,0,7,0,0,0,175,0,189,0,203,0,0,0,172,0,0,0,175,0,0,0,236,0,59,0,142,0,181,0,18,0,16,0,0,0,162,0,90,0,35,0,158,0,195,0,127,0,164,0,102,0,116,0,0,0,57,0,93,0,163,0,51,0,187,0,199,0,192,0,0,0,179,0,74,0,0,0,253,0,158,0,74,0,62,0,141,0,0,0,164,0,0,0,87,0,19,0,165,0,164,0,69,0,0,0,0,0,5,0,0,0,194,0,216,0,17,0,74,0,145,0,21,0,116,0,6,0,142,0,0,0,50,0,241,0,0,0,240,0,196,0,95,0,85,0,206,0,143,0,211,0,164,0,103,0,149,0,252,0,0,0,60,0,208,0,29,0,247,0,9,0,0,0,223,0,0,0,233,0,100,0,50,0,168,0,118,0,66,0,0,0,191,0,184,0,194,0,161,0,148,0,52,0,207,0,225,0,0,0,194,0,162,0,217,0,104,0,0,0,226,0,239,0,14,0,209,0,60,0,0,0,7,0,8,0,156,0,126,0,51,0,0,0,222,0,0,0,112,0,0,0,0,0,198,0);
signal scenario_full  : scenario_type := (121,31,45,31,134,31,84,31,238,31,238,30,238,29,2,31,124,31,65,31,65,30,124,31,147,31,147,30,251,31,216,31,128,31,120,31,112,31,143,31,155,31,217,31,210,31,210,30,28,31,38,31,14,31,122,31,179,31,30,31,186,31,186,30,57,31,57,30,186,31,186,30,100,31,112,31,255,31,255,30,255,29,2,31,179,31,179,30,197,31,216,31,216,30,110,31,110,30,202,31,105,31,42,31,38,31,235,31,82,31,211,31,211,30,48,31,160,31,105,31,221,31,26,31,193,31,221,31,105,31,114,31,241,31,241,30,24,31,187,31,195,31,35,31,158,31,90,31,90,30,100,31,86,31,10,31,85,31,73,31,197,31,197,30,184,31,38,31,129,31,241,31,88,31,62,31,70,31,70,30,70,29,70,28,107,31,31,31,57,31,14,31,143,31,143,30,62,31,90,31,152,31,81,31,177,31,250,31,111,31,111,30,135,31,80,31,87,31,216,31,177,31,114,31,210,31,178,31,123,31,224,31,224,30,204,31,204,30,131,31,33,31,51,31,192,31,154,31,245,31,245,30,245,29,229,31,81,31,4,31,4,30,211,31,70,31,88,31,88,30,5,31,13,31,13,30,131,31,162,31,210,31,210,30,210,29,229,31,229,30,229,29,83,31,136,31,136,30,204,31,123,31,125,31,217,31,164,31,54,31,161,31,161,30,237,31,201,31,31,31,31,30,31,29,60,31,13,31,77,31,77,30,166,31,190,31,39,31,226,31,135,31,63,31,248,31,248,30,32,31,32,30,233,31,187,31,251,31,20,31,20,30,20,29,140,31,144,31,182,31,188,31,103,31,159,31,159,30,5,31,186,31,133,31,19,31,105,31,10,31,254,31,54,31,145,31,168,31,7,31,103,31,111,31,111,30,219,31,50,31,33,31,185,31,141,31,93,31,136,31,136,30,205,31,76,31,76,30,228,31,228,30,118,31,28,31,36,31,161,31,79,31,79,30,214,31,170,31,67,31,67,30,8,31,235,31,205,31,168,31,3,31,44,31,68,31,126,31,116,31,10,31,80,31,76,31,44,31,161,31,206,31,78,31,253,31,72,31,69,31,215,31,249,31,191,31,94,31,108,31,237,31,110,31,187,31,86,31,69,31,139,31,118,31,118,30,131,31,56,31,90,31,90,31,47,31,230,31,188,31,132,31,51,31,51,30,55,31,70,31,94,31,194,31,194,30,129,31,156,31,156,30,203,31,203,31,69,31,5,31,40,31,40,30,205,31,205,30,147,31,147,30,211,31,47,31,58,31,249,31,106,31,222,31,222,30,116,31,229,31,32,31,32,30,150,31,150,30,243,31,164,31,114,31,15,31,232,31,199,31,59,31,36,31,51,31,129,31,196,31,25,31,245,31,102,31,235,31,235,30,92,31,92,30,83,31,24,31,24,30,24,29,210,31,74,31,198,31,198,30,154,31,62,31,240,31,102,31,102,30,205,31,15,31,15,30,15,29,170,31,33,31,220,31,70,31,70,30,230,31,41,31,102,31,215,31,215,30,143,31,12,31,80,31,16,31,16,30,97,31,100,31,142,31,203,31,203,30,86,31,233,31,137,31,137,30,212,31,212,30,96,31,66,31,159,31,29,31,130,31,130,31,127,31,7,31,7,30,175,31,189,31,203,31,203,30,172,31,172,30,175,31,175,30,236,31,59,31,142,31,181,31,18,31,16,31,16,30,162,31,90,31,35,31,158,31,195,31,127,31,164,31,102,31,116,31,116,30,57,31,93,31,163,31,51,31,187,31,199,31,192,31,192,30,179,31,74,31,74,30,253,31,158,31,74,31,62,31,141,31,141,30,164,31,164,30,87,31,19,31,165,31,164,31,69,31,69,30,69,29,5,31,5,30,194,31,216,31,17,31,74,31,145,31,21,31,116,31,6,31,142,31,142,30,50,31,241,31,241,30,240,31,196,31,95,31,85,31,206,31,143,31,211,31,164,31,103,31,149,31,252,31,252,30,60,31,208,31,29,31,247,31,9,31,9,30,223,31,223,30,233,31,100,31,50,31,168,31,118,31,66,31,66,30,191,31,184,31,194,31,161,31,148,31,52,31,207,31,225,31,225,30,194,31,162,31,217,31,104,31,104,30,226,31,239,31,14,31,209,31,60,31,60,30,7,31,8,31,156,31,126,31,51,31,51,30,222,31,222,30,112,31,112,30,112,29,198,31);

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
