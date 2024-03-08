-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_908 is
end project_tb_908;

architecture project_tb_arch_908 of project_tb_908 is
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

constant SCENARIO_LENGTH : integer := 343;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (41,0,188,0,208,0,65,0,0,0,122,0,0,0,114,0,226,0,77,0,133,0,90,0,86,0,0,0,54,0,139,0,126,0,128,0,107,0,51,0,217,0,216,0,250,0,48,0,233,0,135,0,158,0,0,0,225,0,0,0,182,0,0,0,193,0,203,0,0,0,41,0,69,0,135,0,231,0,204,0,212,0,223,0,32,0,173,0,0,0,197,0,0,0,141,0,0,0,22,0,99,0,201,0,96,0,125,0,15,0,214,0,0,0,62,0,248,0,177,0,57,0,205,0,51,0,90,0,75,0,252,0,93,0,118,0,82,0,8,0,65,0,123,0,21,0,78,0,113,0,0,0,175,0,0,0,138,0,202,0,182,0,0,0,125,0,67,0,94,0,0,0,221,0,167,0,0,0,33,0,79,0,157,0,199,0,4,0,60,0,0,0,210,0,126,0,7,0,50,0,0,0,190,0,26,0,107,0,0,0,215,0,232,0,0,0,180,0,181,0,145,0,17,0,136,0,197,0,137,0,233,0,91,0,107,0,118,0,0,0,225,0,197,0,11,0,0,0,118,0,122,0,71,0,36,0,139,0,239,0,176,0,0,0,243,0,98,0,0,0,173,0,24,0,214,0,0,0,186,0,134,0,0,0,238,0,225,0,130,0,0,0,177,0,203,0,23,0,229,0,130,0,241,0,180,0,0,0,5,0,0,0,213,0,253,0,244,0,84,0,0,0,68,0,11,0,84,0,128,0,0,0,248,0,0,0,52,0,0,0,81,0,223,0,211,0,0,0,188,0,203,0,12,0,235,0,121,0,68,0,92,0,186,0,0,0,80,0,0,0,0,0,169,0,104,0,122,0,48,0,29,0,167,0,0,0,104,0,233,0,133,0,154,0,0,0,0,0,218,0,0,0,94,0,178,0,130,0,0,0,236,0,19,0,49,0,0,0,2,0,146,0,58,0,174,0,4,0,0,0,51,0,0,0,211,0,10,0,66,0,0,0,51,0,222,0,0,0,39,0,217,0,190,0,58,0,114,0,36,0,23,0,251,0,242,0,20,0,110,0,42,0,39,0,42,0,166,0,92,0,0,0,89,0,0,0,15,0,207,0,146,0,13,0,0,0,207,0,112,0,49,0,108,0,30,0,13,0,0,0,117,0,118,0,0,0,213,0,95,0,251,0,13,0,0,0,228,0,248,0,248,0,29,0,44,0,0,0,205,0,17,0,62,0,16,0,0,0,21,0,47,0,223,0,58,0,15,0,142,0,97,0,128,0,242,0,43,0,227,0,227,0,0,0,187,0,175,0,173,0,117,0,2,0,181,0,0,0,0,0,250,0,105,0,127,0,0,0,25,0,0,0,240,0,60,0,142,0,0,0,167,0,0,0,44,0,184,0,137,0,229,0,244,0,228,0,144,0,61,0,0,0,114,0,74,0,0,0,99,0,0,0,4,0,17,0,155,0,200,0,105,0,158,0,21,0,106,0,4,0,211,0,0,0,122,0,140,0,31,0,0,0,0,0,249,0,231,0,0,0,0,0,172,0,75,0);
signal scenario_full  : scenario_type := (41,31,188,31,208,31,65,31,65,30,122,31,122,30,114,31,226,31,77,31,133,31,90,31,86,31,86,30,54,31,139,31,126,31,128,31,107,31,51,31,217,31,216,31,250,31,48,31,233,31,135,31,158,31,158,30,225,31,225,30,182,31,182,30,193,31,203,31,203,30,41,31,69,31,135,31,231,31,204,31,212,31,223,31,32,31,173,31,173,30,197,31,197,30,141,31,141,30,22,31,99,31,201,31,96,31,125,31,15,31,214,31,214,30,62,31,248,31,177,31,57,31,205,31,51,31,90,31,75,31,252,31,93,31,118,31,82,31,8,31,65,31,123,31,21,31,78,31,113,31,113,30,175,31,175,30,138,31,202,31,182,31,182,30,125,31,67,31,94,31,94,30,221,31,167,31,167,30,33,31,79,31,157,31,199,31,4,31,60,31,60,30,210,31,126,31,7,31,50,31,50,30,190,31,26,31,107,31,107,30,215,31,232,31,232,30,180,31,181,31,145,31,17,31,136,31,197,31,137,31,233,31,91,31,107,31,118,31,118,30,225,31,197,31,11,31,11,30,118,31,122,31,71,31,36,31,139,31,239,31,176,31,176,30,243,31,98,31,98,30,173,31,24,31,214,31,214,30,186,31,134,31,134,30,238,31,225,31,130,31,130,30,177,31,203,31,23,31,229,31,130,31,241,31,180,31,180,30,5,31,5,30,213,31,253,31,244,31,84,31,84,30,68,31,11,31,84,31,128,31,128,30,248,31,248,30,52,31,52,30,81,31,223,31,211,31,211,30,188,31,203,31,12,31,235,31,121,31,68,31,92,31,186,31,186,30,80,31,80,30,80,29,169,31,104,31,122,31,48,31,29,31,167,31,167,30,104,31,233,31,133,31,154,31,154,30,154,29,218,31,218,30,94,31,178,31,130,31,130,30,236,31,19,31,49,31,49,30,2,31,146,31,58,31,174,31,4,31,4,30,51,31,51,30,211,31,10,31,66,31,66,30,51,31,222,31,222,30,39,31,217,31,190,31,58,31,114,31,36,31,23,31,251,31,242,31,20,31,110,31,42,31,39,31,42,31,166,31,92,31,92,30,89,31,89,30,15,31,207,31,146,31,13,31,13,30,207,31,112,31,49,31,108,31,30,31,13,31,13,30,117,31,118,31,118,30,213,31,95,31,251,31,13,31,13,30,228,31,248,31,248,31,29,31,44,31,44,30,205,31,17,31,62,31,16,31,16,30,21,31,47,31,223,31,58,31,15,31,142,31,97,31,128,31,242,31,43,31,227,31,227,31,227,30,187,31,175,31,173,31,117,31,2,31,181,31,181,30,181,29,250,31,105,31,127,31,127,30,25,31,25,30,240,31,60,31,142,31,142,30,167,31,167,30,44,31,184,31,137,31,229,31,244,31,228,31,144,31,61,31,61,30,114,31,74,31,74,30,99,31,99,30,4,31,17,31,155,31,200,31,105,31,158,31,21,31,106,31,4,31,211,31,211,30,122,31,140,31,31,31,31,30,31,29,249,31,231,31,231,30,231,29,172,31,75,31);

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
