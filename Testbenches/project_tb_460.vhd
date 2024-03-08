-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_460 is
end project_tb_460;

architecture project_tb_arch_460 of project_tb_460 is
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

constant SCENARIO_LENGTH : integer := 454;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (205,0,0,0,0,0,0,0,222,0,42,0,96,0,91,0,20,0,0,0,131,0,105,0,186,0,105,0,0,0,0,0,0,0,30,0,240,0,22,0,74,0,0,0,182,0,3,0,14,0,1,0,181,0,180,0,77,0,54,0,176,0,110,0,245,0,9,0,199,0,49,0,36,0,0,0,82,0,86,0,52,0,0,0,131,0,50,0,72,0,121,0,235,0,182,0,133,0,203,0,161,0,165,0,20,0,57,0,59,0,0,0,36,0,218,0,22,0,116,0,0,0,66,0,0,0,131,0,0,0,118,0,214,0,0,0,12,0,157,0,65,0,0,0,52,0,131,0,158,0,120,0,154,0,37,0,248,0,165,0,0,0,251,0,24,0,115,0,101,0,0,0,127,0,165,0,55,0,174,0,215,0,52,0,19,0,36,0,54,0,0,0,69,0,63,0,234,0,64,0,173,0,196,0,139,0,247,0,20,0,0,0,31,0,214,0,34,0,199,0,250,0,236,0,153,0,0,0,116,0,0,0,0,0,0,0,42,0,34,0,101,0,228,0,192,0,0,0,6,0,139,0,1,0,240,0,0,0,216,0,32,0,190,0,126,0,54,0,192,0,137,0,39,0,3,0,226,0,128,0,92,0,10,0,132,0,212,0,112,0,180,0,20,0,0,0,44,0,15,0,85,0,63,0,197,0,0,0,67,0,40,0,0,0,234,0,0,0,63,0,120,0,35,0,197,0,92,0,187,0,40,0,107,0,2,0,34,0,0,0,225,0,177,0,0,0,0,0,85,0,0,0,98,0,0,0,200,0,171,0,0,0,163,0,0,0,19,0,29,0,228,0,50,0,238,0,89,0,0,0,11,0,87,0,151,0,48,0,187,0,172,0,88,0,0,0,60,0,0,0,105,0,246,0,0,0,0,0,248,0,61,0,98,0,13,0,196,0,42,0,112,0,0,0,0,0,39,0,177,0,210,0,20,0,171,0,123,0,0,0,199,0,79,0,245,0,106,0,246,0,92,0,230,0,71,0,222,0,112,0,108,0,151,0,150,0,95,0,170,0,128,0,239,0,0,0,83,0,46,0,6,0,25,0,0,0,149,0,0,0,207,0,28,0,213,0,109,0,185,0,24,0,12,0,183,0,171,0,74,0,0,0,79,0,162,0,40,0,64,0,58,0,164,0,181,0,113,0,0,0,0,0,31,0,184,0,53,0,77,0,73,0,0,0,153,0,206,0,5,0,0,0,60,0,0,0,0,0,0,0,0,0,57,0,0,0,247,0,185,0,125,0,213,0,76,0,131,0,201,0,172,0,157,0,2,0,187,0,35,0,99,0,244,0,5,0,100,0,13,0,213,0,39,0,174,0,111,0,187,0,158,0,0,0,68,0,0,0,189,0,0,0,150,0,11,0,135,0,246,0,208,0,94,0,225,0,188,0,133,0,252,0,254,0,43,0,217,0,0,0,178,0,144,0,250,0,251,0,0,0,0,0,5,0,32,0,0,0,127,0,0,0,31,0,0,0,179,0,182,0,40,0,132,0,218,0,0,0,0,0,41,0,185,0,125,0,208,0,17,0,0,0,186,0,0,0,163,0,89,0,245,0,0,0,167,0,0,0,236,0,207,0,10,0,0,0,93,0,140,0,184,0,165,0,34,0,150,0,205,0,25,0,219,0,78,0,240,0,38,0,0,0,0,0,222,0,98,0,163,0,67,0,175,0,182,0,18,0,27,0,29,0,145,0,172,0,199,0,90,0,0,0,50,0,209,0,136,0,114,0,17,0,73,0,82,0,68,0,41,0,0,0,93,0,106,0,204,0,0,0,202,0,18,0,0,0,137,0,55,0,157,0,228,0,202,0,89,0,138,0,138,0,156,0,55,0,246,0,213,0,116,0,90,0,43,0,242,0,0,0,176,0,173,0,195,0,181,0,253,0,0,0,76,0,106,0,220,0,0,0,143,0,240,0,165,0,0,0,143,0,148,0,58,0,229,0,255,0,42,0,201,0,0,0,240,0,243,0,0,0,216,0,191,0,0,0,67,0);
signal scenario_full  : scenario_type := (205,31,205,30,205,29,205,28,222,31,42,31,96,31,91,31,20,31,20,30,131,31,105,31,186,31,105,31,105,30,105,29,105,28,30,31,240,31,22,31,74,31,74,30,182,31,3,31,14,31,1,31,181,31,180,31,77,31,54,31,176,31,110,31,245,31,9,31,199,31,49,31,36,31,36,30,82,31,86,31,52,31,52,30,131,31,50,31,72,31,121,31,235,31,182,31,133,31,203,31,161,31,165,31,20,31,57,31,59,31,59,30,36,31,218,31,22,31,116,31,116,30,66,31,66,30,131,31,131,30,118,31,214,31,214,30,12,31,157,31,65,31,65,30,52,31,131,31,158,31,120,31,154,31,37,31,248,31,165,31,165,30,251,31,24,31,115,31,101,31,101,30,127,31,165,31,55,31,174,31,215,31,52,31,19,31,36,31,54,31,54,30,69,31,63,31,234,31,64,31,173,31,196,31,139,31,247,31,20,31,20,30,31,31,214,31,34,31,199,31,250,31,236,31,153,31,153,30,116,31,116,30,116,29,116,28,42,31,34,31,101,31,228,31,192,31,192,30,6,31,139,31,1,31,240,31,240,30,216,31,32,31,190,31,126,31,54,31,192,31,137,31,39,31,3,31,226,31,128,31,92,31,10,31,132,31,212,31,112,31,180,31,20,31,20,30,44,31,15,31,85,31,63,31,197,31,197,30,67,31,40,31,40,30,234,31,234,30,63,31,120,31,35,31,197,31,92,31,187,31,40,31,107,31,2,31,34,31,34,30,225,31,177,31,177,30,177,29,85,31,85,30,98,31,98,30,200,31,171,31,171,30,163,31,163,30,19,31,29,31,228,31,50,31,238,31,89,31,89,30,11,31,87,31,151,31,48,31,187,31,172,31,88,31,88,30,60,31,60,30,105,31,246,31,246,30,246,29,248,31,61,31,98,31,13,31,196,31,42,31,112,31,112,30,112,29,39,31,177,31,210,31,20,31,171,31,123,31,123,30,199,31,79,31,245,31,106,31,246,31,92,31,230,31,71,31,222,31,112,31,108,31,151,31,150,31,95,31,170,31,128,31,239,31,239,30,83,31,46,31,6,31,25,31,25,30,149,31,149,30,207,31,28,31,213,31,109,31,185,31,24,31,12,31,183,31,171,31,74,31,74,30,79,31,162,31,40,31,64,31,58,31,164,31,181,31,113,31,113,30,113,29,31,31,184,31,53,31,77,31,73,31,73,30,153,31,206,31,5,31,5,30,60,31,60,30,60,29,60,28,60,27,57,31,57,30,247,31,185,31,125,31,213,31,76,31,131,31,201,31,172,31,157,31,2,31,187,31,35,31,99,31,244,31,5,31,100,31,13,31,213,31,39,31,174,31,111,31,187,31,158,31,158,30,68,31,68,30,189,31,189,30,150,31,11,31,135,31,246,31,208,31,94,31,225,31,188,31,133,31,252,31,254,31,43,31,217,31,217,30,178,31,144,31,250,31,251,31,251,30,251,29,5,31,32,31,32,30,127,31,127,30,31,31,31,30,179,31,182,31,40,31,132,31,218,31,218,30,218,29,41,31,185,31,125,31,208,31,17,31,17,30,186,31,186,30,163,31,89,31,245,31,245,30,167,31,167,30,236,31,207,31,10,31,10,30,93,31,140,31,184,31,165,31,34,31,150,31,205,31,25,31,219,31,78,31,240,31,38,31,38,30,38,29,222,31,98,31,163,31,67,31,175,31,182,31,18,31,27,31,29,31,145,31,172,31,199,31,90,31,90,30,50,31,209,31,136,31,114,31,17,31,73,31,82,31,68,31,41,31,41,30,93,31,106,31,204,31,204,30,202,31,18,31,18,30,137,31,55,31,157,31,228,31,202,31,89,31,138,31,138,31,156,31,55,31,246,31,213,31,116,31,90,31,43,31,242,31,242,30,176,31,173,31,195,31,181,31,253,31,253,30,76,31,106,31,220,31,220,30,143,31,240,31,165,31,165,30,143,31,148,31,58,31,229,31,255,31,42,31,201,31,201,30,240,31,243,31,243,30,216,31,191,31,191,30,67,31);

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
