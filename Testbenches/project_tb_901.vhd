-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_901 is
end project_tb_901;

architecture project_tb_arch_901 of project_tb_901 is
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

constant SCENARIO_LENGTH : integer := 422;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (74,0,131,0,0,0,59,0,120,0,127,0,38,0,0,0,134,0,26,0,109,0,108,0,51,0,255,0,0,0,30,0,184,0,80,0,172,0,0,0,0,0,39,0,150,0,107,0,0,0,51,0,58,0,36,0,148,0,153,0,37,0,226,0,210,0,89,0,0,0,215,0,0,0,94,0,22,0,234,0,106,0,74,0,211,0,0,0,206,0,101,0,156,0,0,0,226,0,94,0,64,0,208,0,170,0,0,0,0,0,5,0,174,0,135,0,48,0,78,0,155,0,178,0,174,0,0,0,242,0,127,0,148,0,201,0,66,0,42,0,238,0,0,0,0,0,108,0,8,0,141,0,41,0,241,0,176,0,55,0,24,0,0,0,0,0,74,0,221,0,142,0,165,0,191,0,142,0,227,0,0,0,0,0,80,0,19,0,202,0,196,0,55,0,130,0,201,0,48,0,99,0,0,0,0,0,183,0,83,0,0,0,38,0,225,0,106,0,228,0,0,0,228,0,139,0,12,0,71,0,0,0,89,0,42,0,42,0,88,0,20,0,215,0,228,0,250,0,187,0,21,0,136,0,52,0,0,0,14,0,4,0,251,0,49,0,33,0,83,0,0,0,244,0,11,0,92,0,4,0,9,0,195,0,132,0,0,0,173,0,42,0,194,0,44,0,80,0,0,0,70,0,238,0,44,0,89,0,0,0,42,0,38,0,44,0,0,0,218,0,218,0,23,0,88,0,171,0,208,0,0,0,174,0,0,0,0,0,219,0,131,0,44,0,67,0,156,0,0,0,125,0,149,0,0,0,12,0,209,0,75,0,82,0,136,0,147,0,124,0,101,0,0,0,0,0,167,0,115,0,34,0,231,0,0,0,134,0,137,0,0,0,152,0,154,0,0,0,41,0,139,0,0,0,14,0,9,0,226,0,249,0,45,0,0,0,198,0,117,0,35,0,46,0,197,0,0,0,0,0,231,0,119,0,74,0,149,0,152,0,251,0,148,0,164,0,75,0,0,0,66,0,0,0,74,0,29,0,0,0,22,0,14,0,170,0,254,0,173,0,222,0,54,0,214,0,126,0,0,0,45,0,148,0,8,0,0,0,3,0,134,0,0,0,41,0,136,0,200,0,132,0,21,0,235,0,19,0,130,0,240,0,144,0,182,0,96,0,253,0,0,0,70,0,69,0,254,0,0,0,98,0,176,0,167,0,112,0,61,0,0,0,11,0,66,0,230,0,118,0,0,0,243,0,30,0,250,0,13,0,237,0,228,0,254,0,186,0,44,0,128,0,250,0,0,0,236,0,155,0,42,0,200,0,0,0,126,0,218,0,133,0,222,0,48,0,19,0,42,0,204,0,181,0,194,0,95,0,154,0,1,0,216,0,82,0,208,0,7,0,0,0,138,0,0,0,32,0,178,0,200,0,187,0,147,0,111,0,33,0,118,0,201,0,138,0,0,0,78,0,181,0,12,0,56,0,243,0,0,0,0,0,90,0,129,0,0,0,175,0,85,0,0,0,242,0,0,0,169,0,207,0,0,0,0,0,84,0,112,0,0,0,48,0,0,0,51,0,43,0,2,0,48,0,151,0,118,0,34,0,216,0,216,0,10,0,0,0,137,0,52,0,0,0,193,0,57,0,198,0,0,0,188,0,216,0,0,0,42,0,0,0,109,0,0,0,66,0,17,0,231,0,116,0,27,0,193,0,107,0,0,0,154,0,193,0,186,0,97,0,198,0,0,0,191,0,75,0,0,0,150,0,67,0,191,0,0,0,119,0,118,0,37,0,0,0,221,0,244,0,207,0,213,0,0,0,172,0,117,0,250,0,0,0,203,0,0,0,215,0,135,0,0,0,85,0,0,0,143,0,190,0,55,0,49,0,0,0,102,0,95,0,235,0);
signal scenario_full  : scenario_type := (74,31,131,31,131,30,59,31,120,31,127,31,38,31,38,30,134,31,26,31,109,31,108,31,51,31,255,31,255,30,30,31,184,31,80,31,172,31,172,30,172,29,39,31,150,31,107,31,107,30,51,31,58,31,36,31,148,31,153,31,37,31,226,31,210,31,89,31,89,30,215,31,215,30,94,31,22,31,234,31,106,31,74,31,211,31,211,30,206,31,101,31,156,31,156,30,226,31,94,31,64,31,208,31,170,31,170,30,170,29,5,31,174,31,135,31,48,31,78,31,155,31,178,31,174,31,174,30,242,31,127,31,148,31,201,31,66,31,42,31,238,31,238,30,238,29,108,31,8,31,141,31,41,31,241,31,176,31,55,31,24,31,24,30,24,29,74,31,221,31,142,31,165,31,191,31,142,31,227,31,227,30,227,29,80,31,19,31,202,31,196,31,55,31,130,31,201,31,48,31,99,31,99,30,99,29,183,31,83,31,83,30,38,31,225,31,106,31,228,31,228,30,228,31,139,31,12,31,71,31,71,30,89,31,42,31,42,31,88,31,20,31,215,31,228,31,250,31,187,31,21,31,136,31,52,31,52,30,14,31,4,31,251,31,49,31,33,31,83,31,83,30,244,31,11,31,92,31,4,31,9,31,195,31,132,31,132,30,173,31,42,31,194,31,44,31,80,31,80,30,70,31,238,31,44,31,89,31,89,30,42,31,38,31,44,31,44,30,218,31,218,31,23,31,88,31,171,31,208,31,208,30,174,31,174,30,174,29,219,31,131,31,44,31,67,31,156,31,156,30,125,31,149,31,149,30,12,31,209,31,75,31,82,31,136,31,147,31,124,31,101,31,101,30,101,29,167,31,115,31,34,31,231,31,231,30,134,31,137,31,137,30,152,31,154,31,154,30,41,31,139,31,139,30,14,31,9,31,226,31,249,31,45,31,45,30,198,31,117,31,35,31,46,31,197,31,197,30,197,29,231,31,119,31,74,31,149,31,152,31,251,31,148,31,164,31,75,31,75,30,66,31,66,30,74,31,29,31,29,30,22,31,14,31,170,31,254,31,173,31,222,31,54,31,214,31,126,31,126,30,45,31,148,31,8,31,8,30,3,31,134,31,134,30,41,31,136,31,200,31,132,31,21,31,235,31,19,31,130,31,240,31,144,31,182,31,96,31,253,31,253,30,70,31,69,31,254,31,254,30,98,31,176,31,167,31,112,31,61,31,61,30,11,31,66,31,230,31,118,31,118,30,243,31,30,31,250,31,13,31,237,31,228,31,254,31,186,31,44,31,128,31,250,31,250,30,236,31,155,31,42,31,200,31,200,30,126,31,218,31,133,31,222,31,48,31,19,31,42,31,204,31,181,31,194,31,95,31,154,31,1,31,216,31,82,31,208,31,7,31,7,30,138,31,138,30,32,31,178,31,200,31,187,31,147,31,111,31,33,31,118,31,201,31,138,31,138,30,78,31,181,31,12,31,56,31,243,31,243,30,243,29,90,31,129,31,129,30,175,31,85,31,85,30,242,31,242,30,169,31,207,31,207,30,207,29,84,31,112,31,112,30,48,31,48,30,51,31,43,31,2,31,48,31,151,31,118,31,34,31,216,31,216,31,10,31,10,30,137,31,52,31,52,30,193,31,57,31,198,31,198,30,188,31,216,31,216,30,42,31,42,30,109,31,109,30,66,31,17,31,231,31,116,31,27,31,193,31,107,31,107,30,154,31,193,31,186,31,97,31,198,31,198,30,191,31,75,31,75,30,150,31,67,31,191,31,191,30,119,31,118,31,37,31,37,30,221,31,244,31,207,31,213,31,213,30,172,31,117,31,250,31,250,30,203,31,203,30,215,31,135,31,135,30,85,31,85,30,143,31,190,31,55,31,49,31,49,30,102,31,95,31,235,31);

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
