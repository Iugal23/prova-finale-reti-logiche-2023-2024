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

constant SCENARIO_LENGTH : integer := 395;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (202,0,139,0,110,0,144,0,32,0,103,0,103,0,245,0,151,0,166,0,0,0,11,0,255,0,22,0,77,0,201,0,58,0,72,0,142,0,107,0,0,0,70,0,115,0,220,0,100,0,239,0,203,0,0,0,0,0,0,0,161,0,153,0,10,0,0,0,208,0,4,0,39,0,0,0,202,0,179,0,151,0,6,0,215,0,159,0,0,0,0,0,222,0,135,0,133,0,130,0,0,0,155,0,217,0,0,0,33,0,0,0,0,0,0,0,176,0,0,0,32,0,0,0,254,0,104,0,24,0,14,0,11,0,4,0,54,0,26,0,159,0,230,0,0,0,0,0,0,0,113,0,0,0,0,0,48,0,87,0,0,0,0,0,0,0,54,0,0,0,179,0,83,0,0,0,106,0,0,0,243,0,153,0,119,0,53,0,192,0,0,0,0,0,16,0,25,0,125,0,7,0,10,0,0,0,13,0,85,0,194,0,100,0,0,0,37,0,19,0,39,0,78,0,105,0,226,0,185,0,157,0,13,0,27,0,0,0,153,0,66,0,209,0,0,0,121,0,126,0,195,0,185,0,243,0,0,0,0,0,205,0,119,0,170,0,210,0,50,0,175,0,254,0,0,0,173,0,25,0,0,0,224,0,0,0,0,0,0,0,59,0,135,0,0,0,156,0,105,0,81,0,211,0,99,0,111,0,0,0,147,0,53,0,170,0,226,0,86,0,100,0,107,0,8,0,240,0,44,0,63,0,234,0,40,0,68,0,127,0,130,0,53,0,149,0,207,0,239,0,197,0,172,0,241,0,173,0,0,0,55,0,114,0,109,0,236,0,99,0,0,0,0,0,139,0,228,0,0,0,243,0,0,0,39,0,87,0,85,0,189,0,131,0,82,0,181,0,146,0,49,0,14,0,247,0,246,0,11,0,175,0,96,0,141,0,118,0,167,0,228,0,119,0,188,0,156,0,208,0,149,0,134,0,139,0,108,0,213,0,72,0,95,0,0,0,123,0,0,0,0,0,231,0,200,0,71,0,182,0,254,0,26,0,208,0,165,0,237,0,128,0,239,0,0,0,0,0,177,0,0,0,230,0,182,0,196,0,207,0,0,0,109,0,0,0,21,0,0,0,0,0,83,0,71,0,79,0,73,0,194,0,0,0,51,0,0,0,150,0,118,0,95,0,113,0,118,0,200,0,164,0,146,0,110,0,213,0,0,0,0,0,0,0,110,0,117,0,219,0,0,0,3,0,176,0,252,0,17,0,189,0,23,0,235,0,172,0,0,0,121,0,148,0,147,0,217,0,17,0,0,0,114,0,248,0,102,0,141,0,94,0,68,0,212,0,1,0,165,0,98,0,251,0,198,0,239,0,161,0,206,0,186,0,14,0,118,0,199,0,213,0,73,0,225,0,81,0,235,0,179,0,170,0,80,0,96,0,237,0,19,0,98,0,146,0,0,0,0,0,222,0,253,0,180,0,7,0,15,0,12,0,18,0,117,0,53,0,44,0,0,0,16,0,0,0,217,0,0,0,57,0,0,0,207,0,187,0,90,0,1,0,52,0,0,0,210,0,120,0,71,0,85,0,86,0,0,0,0,0,0,0,10,0,59,0,159,0,45,0,162,0,167,0,35,0,28,0,142,0,228,0,0,0,115,0,65,0,46,0,0,0,137,0,186,0,113,0,129,0,0,0,162,0,77,0,0,0,142,0,147,0,0,0,195,0,255,0,0,0,68,0,51,0,99,0,145,0,100,0,38,0,113,0,0,0,164,0,0,0);
signal scenario_full  : scenario_type := (202,31,139,31,110,31,144,31,32,31,103,31,103,31,245,31,151,31,166,31,166,30,11,31,255,31,22,31,77,31,201,31,58,31,72,31,142,31,107,31,107,30,70,31,115,31,220,31,100,31,239,31,203,31,203,30,203,29,203,28,161,31,153,31,10,31,10,30,208,31,4,31,39,31,39,30,202,31,179,31,151,31,6,31,215,31,159,31,159,30,159,29,222,31,135,31,133,31,130,31,130,30,155,31,217,31,217,30,33,31,33,30,33,29,33,28,176,31,176,30,32,31,32,30,254,31,104,31,24,31,14,31,11,31,4,31,54,31,26,31,159,31,230,31,230,30,230,29,230,28,113,31,113,30,113,29,48,31,87,31,87,30,87,29,87,28,54,31,54,30,179,31,83,31,83,30,106,31,106,30,243,31,153,31,119,31,53,31,192,31,192,30,192,29,16,31,25,31,125,31,7,31,10,31,10,30,13,31,85,31,194,31,100,31,100,30,37,31,19,31,39,31,78,31,105,31,226,31,185,31,157,31,13,31,27,31,27,30,153,31,66,31,209,31,209,30,121,31,126,31,195,31,185,31,243,31,243,30,243,29,205,31,119,31,170,31,210,31,50,31,175,31,254,31,254,30,173,31,25,31,25,30,224,31,224,30,224,29,224,28,59,31,135,31,135,30,156,31,105,31,81,31,211,31,99,31,111,31,111,30,147,31,53,31,170,31,226,31,86,31,100,31,107,31,8,31,240,31,44,31,63,31,234,31,40,31,68,31,127,31,130,31,53,31,149,31,207,31,239,31,197,31,172,31,241,31,173,31,173,30,55,31,114,31,109,31,236,31,99,31,99,30,99,29,139,31,228,31,228,30,243,31,243,30,39,31,87,31,85,31,189,31,131,31,82,31,181,31,146,31,49,31,14,31,247,31,246,31,11,31,175,31,96,31,141,31,118,31,167,31,228,31,119,31,188,31,156,31,208,31,149,31,134,31,139,31,108,31,213,31,72,31,95,31,95,30,123,31,123,30,123,29,231,31,200,31,71,31,182,31,254,31,26,31,208,31,165,31,237,31,128,31,239,31,239,30,239,29,177,31,177,30,230,31,182,31,196,31,207,31,207,30,109,31,109,30,21,31,21,30,21,29,83,31,71,31,79,31,73,31,194,31,194,30,51,31,51,30,150,31,118,31,95,31,113,31,118,31,200,31,164,31,146,31,110,31,213,31,213,30,213,29,213,28,110,31,117,31,219,31,219,30,3,31,176,31,252,31,17,31,189,31,23,31,235,31,172,31,172,30,121,31,148,31,147,31,217,31,17,31,17,30,114,31,248,31,102,31,141,31,94,31,68,31,212,31,1,31,165,31,98,31,251,31,198,31,239,31,161,31,206,31,186,31,14,31,118,31,199,31,213,31,73,31,225,31,81,31,235,31,179,31,170,31,80,31,96,31,237,31,19,31,98,31,146,31,146,30,146,29,222,31,253,31,180,31,7,31,15,31,12,31,18,31,117,31,53,31,44,31,44,30,16,31,16,30,217,31,217,30,57,31,57,30,207,31,187,31,90,31,1,31,52,31,52,30,210,31,120,31,71,31,85,31,86,31,86,30,86,29,86,28,10,31,59,31,159,31,45,31,162,31,167,31,35,31,28,31,142,31,228,31,228,30,115,31,65,31,46,31,46,30,137,31,186,31,113,31,129,31,129,30,162,31,77,31,77,30,142,31,147,31,147,30,195,31,255,31,255,30,68,31,51,31,99,31,145,31,100,31,38,31,113,31,113,30,164,31,164,30);

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
