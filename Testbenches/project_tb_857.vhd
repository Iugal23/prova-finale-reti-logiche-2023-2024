-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_857 is
end project_tb_857;

architecture project_tb_arch_857 of project_tb_857 is
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

constant SCENARIO_LENGTH : integer := 518;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (226,0,27,0,212,0,96,0,58,0,0,0,145,0,0,0,198,0,0,0,0,0,174,0,50,0,78,0,20,0,9,0,0,0,0,0,159,0,41,0,101,0,123,0,181,0,138,0,119,0,3,0,106,0,0,0,14,0,65,0,208,0,98,0,229,0,0,0,0,0,28,0,32,0,114,0,111,0,80,0,37,0,76,0,0,0,210,0,212,0,171,0,155,0,45,0,119,0,51,0,33,0,134,0,186,0,56,0,83,0,0,0,0,0,0,0,227,0,0,0,66,0,98,0,97,0,63,0,190,0,52,0,0,0,57,0,187,0,167,0,192,0,161,0,200,0,156,0,0,0,168,0,0,0,0,0,75,0,71,0,0,0,0,0,197,0,122,0,222,0,0,0,107,0,62,0,237,0,206,0,0,0,11,0,0,0,179,0,0,0,35,0,26,0,227,0,55,0,92,0,201,0,0,0,134,0,131,0,184,0,93,0,0,0,216,0,20,0,83,0,207,0,29,0,230,0,91,0,251,0,37,0,0,0,181,0,0,0,36,0,104,0,0,0,105,0,58,0,0,0,104,0,60,0,0,0,37,0,148,0,199,0,33,0,178,0,120,0,126,0,0,0,209,0,199,0,69,0,157,0,9,0,143,0,222,0,5,0,123,0,0,0,42,0,17,0,9,0,107,0,203,0,78,0,156,0,189,0,231,0,48,0,0,0,20,0,63,0,0,0,0,0,248,0,31,0,0,0,203,0,28,0,222,0,184,0,196,0,173,0,120,0,115,0,106,0,46,0,121,0,0,0,0,0,181,0,0,0,218,0,0,0,134,0,231,0,218,0,68,0,102,0,30,0,64,0,207,0,101,0,13,0,174,0,0,0,4,0,111,0,209,0,14,0,0,0,65,0,88,0,164,0,164,0,166,0,42,0,96,0,199,0,18,0,117,0,117,0,20,0,233,0,204,0,60,0,195,0,193,0,46,0,0,0,95,0,123,0,0,0,225,0,89,0,7,0,218,0,0,0,0,0,0,0,184,0,195,0,250,0,58,0,0,0,86,0,0,0,94,0,70,0,0,0,87,0,0,0,5,0,178,0,5,0,130,0,209,0,114,0,97,0,0,0,155,0,252,0,84,0,39,0,169,0,0,0,228,0,223,0,63,0,74,0,146,0,180,0,208,0,150,0,64,0,0,0,0,0,169,0,217,0,180,0,56,0,205,0,129,0,67,0,5,0,25,0,99,0,117,0,0,0,128,0,0,0,172,0,51,0,190,0,249,0,0,0,0,0,152,0,252,0,218,0,102,0,26,0,235,0,188,0,83,0,94,0,185,0,39,0,161,0,149,0,0,0,146,0,0,0,14,0,71,0,148,0,136,0,154,0,0,0,118,0,120,0,155,0,22,0,0,0,0,0,0,0,150,0,154,0,126,0,113,0,0,0,0,0,96,0,158,0,250,0,3,0,88,0,0,0,70,0,0,0,221,0,241,0,206,0,237,0,114,0,0,0,237,0,0,0,132,0,25,0,173,0,0,0,91,0,0,0,0,0,0,0,186,0,0,0,0,0,158,0,203,0,0,0,195,0,122,0,0,0,101,0,37,0,0,0,114,0,0,0,0,0,0,0,103,0,0,0,176,0,14,0,236,0,230,0,229,0,68,0,189,0,40,0,145,0,206,0,153,0,101,0,0,0,159,0,0,0,6,0,6,0,209,0,139,0,119,0,114,0,0,0,208,0,246,0,0,0,135,0,199,0,17,0,54,0,0,0,0,0,36,0,0,0,52,0,0,0,66,0,134,0,162,0,190,0,0,0,136,0,93,0,62,0,70,0,54,0,63,0,107,0,55,0,23,0,151,0,33,0,155,0,216,0,234,0,149,0,142,0,98,0,56,0,60,0,55,0,48,0,199,0,0,0,0,0,236,0,1,0,0,0,0,0,0,0,184,0,81,0,215,0,0,0,101,0,27,0,0,0,0,0,90,0,65,0,175,0,149,0,10,0,61,0,162,0,72,0,11,0,84,0,24,0,56,0,182,0,23,0,66,0,36,0,0,0,195,0,47,0,57,0,183,0,230,0,0,0,30,0,72,0,141,0,132,0,92,0,219,0,0,0,101,0,0,0,154,0,108,0,183,0,142,0,133,0,235,0,196,0,0,0,196,0,184,0,142,0,148,0,170,0,0,0,248,0,76,0,0,0,0,0,35,0,42,0,199,0,250,0,77,0,0,0,120,0,242,0,51,0,0,0,47,0,4,0,0,0,17,0,126,0,28,0,179,0,207,0,206,0,126,0,240,0,57,0,103,0,245,0,0,0,131,0,153,0,0,0,119,0,36,0);
signal scenario_full  : scenario_type := (226,31,27,31,212,31,96,31,58,31,58,30,145,31,145,30,198,31,198,30,198,29,174,31,50,31,78,31,20,31,9,31,9,30,9,29,159,31,41,31,101,31,123,31,181,31,138,31,119,31,3,31,106,31,106,30,14,31,65,31,208,31,98,31,229,31,229,30,229,29,28,31,32,31,114,31,111,31,80,31,37,31,76,31,76,30,210,31,212,31,171,31,155,31,45,31,119,31,51,31,33,31,134,31,186,31,56,31,83,31,83,30,83,29,83,28,227,31,227,30,66,31,98,31,97,31,63,31,190,31,52,31,52,30,57,31,187,31,167,31,192,31,161,31,200,31,156,31,156,30,168,31,168,30,168,29,75,31,71,31,71,30,71,29,197,31,122,31,222,31,222,30,107,31,62,31,237,31,206,31,206,30,11,31,11,30,179,31,179,30,35,31,26,31,227,31,55,31,92,31,201,31,201,30,134,31,131,31,184,31,93,31,93,30,216,31,20,31,83,31,207,31,29,31,230,31,91,31,251,31,37,31,37,30,181,31,181,30,36,31,104,31,104,30,105,31,58,31,58,30,104,31,60,31,60,30,37,31,148,31,199,31,33,31,178,31,120,31,126,31,126,30,209,31,199,31,69,31,157,31,9,31,143,31,222,31,5,31,123,31,123,30,42,31,17,31,9,31,107,31,203,31,78,31,156,31,189,31,231,31,48,31,48,30,20,31,63,31,63,30,63,29,248,31,31,31,31,30,203,31,28,31,222,31,184,31,196,31,173,31,120,31,115,31,106,31,46,31,121,31,121,30,121,29,181,31,181,30,218,31,218,30,134,31,231,31,218,31,68,31,102,31,30,31,64,31,207,31,101,31,13,31,174,31,174,30,4,31,111,31,209,31,14,31,14,30,65,31,88,31,164,31,164,31,166,31,42,31,96,31,199,31,18,31,117,31,117,31,20,31,233,31,204,31,60,31,195,31,193,31,46,31,46,30,95,31,123,31,123,30,225,31,89,31,7,31,218,31,218,30,218,29,218,28,184,31,195,31,250,31,58,31,58,30,86,31,86,30,94,31,70,31,70,30,87,31,87,30,5,31,178,31,5,31,130,31,209,31,114,31,97,31,97,30,155,31,252,31,84,31,39,31,169,31,169,30,228,31,223,31,63,31,74,31,146,31,180,31,208,31,150,31,64,31,64,30,64,29,169,31,217,31,180,31,56,31,205,31,129,31,67,31,5,31,25,31,99,31,117,31,117,30,128,31,128,30,172,31,51,31,190,31,249,31,249,30,249,29,152,31,252,31,218,31,102,31,26,31,235,31,188,31,83,31,94,31,185,31,39,31,161,31,149,31,149,30,146,31,146,30,14,31,71,31,148,31,136,31,154,31,154,30,118,31,120,31,155,31,22,31,22,30,22,29,22,28,150,31,154,31,126,31,113,31,113,30,113,29,96,31,158,31,250,31,3,31,88,31,88,30,70,31,70,30,221,31,241,31,206,31,237,31,114,31,114,30,237,31,237,30,132,31,25,31,173,31,173,30,91,31,91,30,91,29,91,28,186,31,186,30,186,29,158,31,203,31,203,30,195,31,122,31,122,30,101,31,37,31,37,30,114,31,114,30,114,29,114,28,103,31,103,30,176,31,14,31,236,31,230,31,229,31,68,31,189,31,40,31,145,31,206,31,153,31,101,31,101,30,159,31,159,30,6,31,6,31,209,31,139,31,119,31,114,31,114,30,208,31,246,31,246,30,135,31,199,31,17,31,54,31,54,30,54,29,36,31,36,30,52,31,52,30,66,31,134,31,162,31,190,31,190,30,136,31,93,31,62,31,70,31,54,31,63,31,107,31,55,31,23,31,151,31,33,31,155,31,216,31,234,31,149,31,142,31,98,31,56,31,60,31,55,31,48,31,199,31,199,30,199,29,236,31,1,31,1,30,1,29,1,28,184,31,81,31,215,31,215,30,101,31,27,31,27,30,27,29,90,31,65,31,175,31,149,31,10,31,61,31,162,31,72,31,11,31,84,31,24,31,56,31,182,31,23,31,66,31,36,31,36,30,195,31,47,31,57,31,183,31,230,31,230,30,30,31,72,31,141,31,132,31,92,31,219,31,219,30,101,31,101,30,154,31,108,31,183,31,142,31,133,31,235,31,196,31,196,30,196,31,184,31,142,31,148,31,170,31,170,30,248,31,76,31,76,30,76,29,35,31,42,31,199,31,250,31,77,31,77,30,120,31,242,31,51,31,51,30,47,31,4,31,4,30,17,31,126,31,28,31,179,31,207,31,206,31,126,31,240,31,57,31,103,31,245,31,245,30,131,31,153,31,153,30,119,31,36,31);

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
