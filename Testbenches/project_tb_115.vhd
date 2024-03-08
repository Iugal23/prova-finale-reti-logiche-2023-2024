-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_115 is
end project_tb_115;

architecture project_tb_arch_115 of project_tb_115 is
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

constant SCENARIO_LENGTH : integer := 426;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (141,0,0,0,0,0,63,0,194,0,146,0,67,0,85,0,147,0,183,0,125,0,177,0,2,0,0,0,151,0,127,0,148,0,0,0,0,0,138,0,0,0,49,0,165,0,28,0,219,0,67,0,68,0,92,0,111,0,241,0,100,0,203,0,111,0,211,0,235,0,63,0,190,0,73,0,181,0,161,0,112,0,213,0,9,0,189,0,44,0,219,0,197,0,0,0,206,0,111,0,129,0,199,0,0,0,146,0,178,0,58,0,211,0,113,0,0,0,177,0,109,0,0,0,70,0,112,0,30,0,18,0,223,0,58,0,215,0,3,0,112,0,22,0,24,0,255,0,174,0,151,0,120,0,214,0,16,0,101,0,229,0,10,0,74,0,32,0,204,0,153,0,0,0,246,0,220,0,213,0,102,0,36,0,57,0,71,0,0,0,92,0,177,0,0,0,133,0,0,0,236,0,208,0,53,0,36,0,202,0,27,0,123,0,252,0,16,0,122,0,2,0,0,0,121,0,45,0,246,0,162,0,231,0,0,0,144,0,111,0,148,0,212,0,0,0,34,0,194,0,0,0,104,0,107,0,148,0,206,0,92,0,53,0,0,0,6,0,7,0,0,0,12,0,186,0,125,0,187,0,144,0,66,0,22,0,116,0,144,0,89,0,0,0,255,0,0,0,162,0,58,0,37,0,0,0,40,0,127,0,106,0,39,0,3,0,223,0,84,0,229,0,230,0,0,0,203,0,0,0,205,0,215,0,88,0,240,0,250,0,241,0,229,0,11,0,95,0,0,0,22,0,167,0,39,0,176,0,52,0,244,0,0,0,164,0,102,0,0,0,35,0,85,0,225,0,0,0,0,0,64,0,217,0,21,0,181,0,0,0,0,0,187,0,142,0,218,0,122,0,205,0,112,0,161,0,184,0,8,0,113,0,27,0,0,0,0,0,217,0,34,0,0,0,0,0,120,0,0,0,0,0,0,0,26,0,220,0,27,0,103,0,200,0,4,0,102,0,19,0,250,0,103,0,90,0,243,0,31,0,115,0,0,0,0,0,0,0,178,0,0,0,189,0,10,0,157,0,136,0,131,0,16,0,0,0,65,0,242,0,235,0,0,0,68,0,64,0,242,0,44,0,247,0,238,0,215,0,135,0,172,0,225,0,0,0,38,0,0,0,241,0,0,0,10,0,51,0,173,0,0,0,29,0,0,0,238,0,204,0,100,0,89,0,13,0,0,0,0,0,209,0,79,0,215,0,123,0,239,0,248,0,27,0,57,0,77,0,246,0,212,0,157,0,175,0,32,0,0,0,31,0,0,0,234,0,71,0,41,0,104,0,109,0,33,0,131,0,0,0,117,0,253,0,249,0,71,0,227,0,146,0,230,0,218,0,69,0,122,0,0,0,0,0,60,0,13,0,114,0,108,0,23,0,132,0,79,0,0,0,217,0,159,0,1,0,45,0,242,0,0,0,216,0,200,0,206,0,0,0,107,0,0,0,0,0,80,0,39,0,73,0,114,0,88,0,54,0,21,0,60,0,244,0,0,0,17,0,147,0,21,0,244,0,0,0,0,0,30,0,5,0,131,0,0,0,248,0,247,0,0,0,158,0,94,0,155,0,0,0,28,0,223,0,142,0,152,0,128,0,176,0,27,0,31,0,0,0,201,0,19,0,167,0,0,0,47,0,55,0,3,0,230,0,126,0,33,0,217,0,46,0,14,0,206,0,63,0,14,0,4,0,90,0,143,0,136,0,168,0,125,0,19,0,109,0,107,0,0,0,178,0,213,0,181,0,113,0,196,0,87,0,0,0,199,0,86,0,173,0,254,0,0,0,238,0,206,0,154,0,68,0,99,0,214,0,3,0,181,0,108,0,105,0,107,0,165,0,8,0,212,0,138,0,64,0,183,0,168,0,81,0);
signal scenario_full  : scenario_type := (141,31,141,30,141,29,63,31,194,31,146,31,67,31,85,31,147,31,183,31,125,31,177,31,2,31,2,30,151,31,127,31,148,31,148,30,148,29,138,31,138,30,49,31,165,31,28,31,219,31,67,31,68,31,92,31,111,31,241,31,100,31,203,31,111,31,211,31,235,31,63,31,190,31,73,31,181,31,161,31,112,31,213,31,9,31,189,31,44,31,219,31,197,31,197,30,206,31,111,31,129,31,199,31,199,30,146,31,178,31,58,31,211,31,113,31,113,30,177,31,109,31,109,30,70,31,112,31,30,31,18,31,223,31,58,31,215,31,3,31,112,31,22,31,24,31,255,31,174,31,151,31,120,31,214,31,16,31,101,31,229,31,10,31,74,31,32,31,204,31,153,31,153,30,246,31,220,31,213,31,102,31,36,31,57,31,71,31,71,30,92,31,177,31,177,30,133,31,133,30,236,31,208,31,53,31,36,31,202,31,27,31,123,31,252,31,16,31,122,31,2,31,2,30,121,31,45,31,246,31,162,31,231,31,231,30,144,31,111,31,148,31,212,31,212,30,34,31,194,31,194,30,104,31,107,31,148,31,206,31,92,31,53,31,53,30,6,31,7,31,7,30,12,31,186,31,125,31,187,31,144,31,66,31,22,31,116,31,144,31,89,31,89,30,255,31,255,30,162,31,58,31,37,31,37,30,40,31,127,31,106,31,39,31,3,31,223,31,84,31,229,31,230,31,230,30,203,31,203,30,205,31,215,31,88,31,240,31,250,31,241,31,229,31,11,31,95,31,95,30,22,31,167,31,39,31,176,31,52,31,244,31,244,30,164,31,102,31,102,30,35,31,85,31,225,31,225,30,225,29,64,31,217,31,21,31,181,31,181,30,181,29,187,31,142,31,218,31,122,31,205,31,112,31,161,31,184,31,8,31,113,31,27,31,27,30,27,29,217,31,34,31,34,30,34,29,120,31,120,30,120,29,120,28,26,31,220,31,27,31,103,31,200,31,4,31,102,31,19,31,250,31,103,31,90,31,243,31,31,31,115,31,115,30,115,29,115,28,178,31,178,30,189,31,10,31,157,31,136,31,131,31,16,31,16,30,65,31,242,31,235,31,235,30,68,31,64,31,242,31,44,31,247,31,238,31,215,31,135,31,172,31,225,31,225,30,38,31,38,30,241,31,241,30,10,31,51,31,173,31,173,30,29,31,29,30,238,31,204,31,100,31,89,31,13,31,13,30,13,29,209,31,79,31,215,31,123,31,239,31,248,31,27,31,57,31,77,31,246,31,212,31,157,31,175,31,32,31,32,30,31,31,31,30,234,31,71,31,41,31,104,31,109,31,33,31,131,31,131,30,117,31,253,31,249,31,71,31,227,31,146,31,230,31,218,31,69,31,122,31,122,30,122,29,60,31,13,31,114,31,108,31,23,31,132,31,79,31,79,30,217,31,159,31,1,31,45,31,242,31,242,30,216,31,200,31,206,31,206,30,107,31,107,30,107,29,80,31,39,31,73,31,114,31,88,31,54,31,21,31,60,31,244,31,244,30,17,31,147,31,21,31,244,31,244,30,244,29,30,31,5,31,131,31,131,30,248,31,247,31,247,30,158,31,94,31,155,31,155,30,28,31,223,31,142,31,152,31,128,31,176,31,27,31,31,31,31,30,201,31,19,31,167,31,167,30,47,31,55,31,3,31,230,31,126,31,33,31,217,31,46,31,14,31,206,31,63,31,14,31,4,31,90,31,143,31,136,31,168,31,125,31,19,31,109,31,107,31,107,30,178,31,213,31,181,31,113,31,196,31,87,31,87,30,199,31,86,31,173,31,254,31,254,30,238,31,206,31,154,31,68,31,99,31,214,31,3,31,181,31,108,31,105,31,107,31,165,31,8,31,212,31,138,31,64,31,183,31,168,31,81,31);

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
