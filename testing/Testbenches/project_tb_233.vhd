-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_233 is
end project_tb_233;

architecture project_tb_arch_233 of project_tb_233 is
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

constant SCENARIO_LENGTH : integer := 390;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,94,0,0,0,0,0,83,0,177,0,53,0,235,0,0,0,227,0,0,0,104,0,20,0,73,0,0,0,68,0,213,0,191,0,50,0,158,0,194,0,34,0,189,0,123,0,222,0,0,0,172,0,26,0,167,0,132,0,246,0,108,0,175,0,218,0,180,0,144,0,124,0,0,0,82,0,18,0,152,0,71,0,125,0,22,0,7,0,90,0,0,0,246,0,0,0,34,0,60,0,196,0,241,0,165,0,105,0,134,0,125,0,0,0,56,0,174,0,125,0,230,0,0,0,179,0,151,0,160,0,44,0,151,0,6,0,0,0,37,0,250,0,0,0,26,0,113,0,0,0,109,0,228,0,190,0,114,0,16,0,189,0,216,0,0,0,110,0,202,0,0,0,124,0,227,0,165,0,20,0,136,0,202,0,179,0,251,0,0,0,0,0,0,0,14,0,255,0,128,0,180,0,47,0,172,0,0,0,0,0,212,0,160,0,0,0,136,0,144,0,211,0,0,0,41,0,82,0,171,0,0,0,0,0,158,0,149,0,35,0,0,0,142,0,89,0,117,0,10,0,135,0,204,0,93,0,103,0,194,0,121,0,62,0,70,0,201,0,78,0,146,0,77,0,45,0,249,0,44,0,85,0,228,0,213,0,240,0,104,0,0,0,191,0,47,0,247,0,164,0,0,0,0,0,90,0,130,0,0,0,16,0,205,0,106,0,0,0,33,0,104,0,139,0,0,0,62,0,0,0,105,0,202,0,50,0,208,0,0,0,55,0,18,0,184,0,2,0,0,0,240,0,216,0,0,0,230,0,32,0,157,0,236,0,224,0,254,0,51,0,29,0,204,0,202,0,78,0,234,0,244,0,170,0,8,0,0,0,235,0,77,0,226,0,38,0,33,0,151,0,161,0,0,0,104,0,243,0,241,0,222,0,22,0,0,0,182,0,184,0,182,0,236,0,236,0,189,0,113,0,168,0,174,0,155,0,0,0,99,0,36,0,191,0,55,0,65,0,68,0,0,0,220,0,166,0,208,0,113,0,34,0,151,0,83,0,97,0,250,0,116,0,32,0,16,0,76,0,0,0,71,0,42,0,36,0,254,0,43,0,0,0,40,0,10,0,22,0,0,0,181,0,115,0,98,0,100,0,147,0,160,0,135,0,0,0,212,0,236,0,254,0,20,0,103,0,168,0,159,0,0,0,229,0,219,0,153,0,92,0,0,0,56,0,59,0,24,0,248,0,27,0,179,0,31,0,233,0,0,0,232,0,71,0,0,0,167,0,126,0,236,0,184,0,0,0,211,0,119,0,27,0,205,0,0,0,0,0,70,0,254,0,188,0,100,0,251,0,89,0,195,0,186,0,8,0,45,0,239,0,92,0,245,0,79,0,190,0,0,0,131,0,227,0,107,0,0,0,197,0,8,0,0,0,82,0,41,0,1,0,70,0,141,0,171,0,227,0,124,0,233,0,4,0,160,0,165,0,0,0,0,0,158,0,185,0,3,0,183,0,124,0,94,0,217,0,132,0,0,0,0,0,74,0,203,0,69,0,228,0,161,0,65,0,51,0,2,0,51,0,89,0,180,0,75,0,200,0,198,0,81,0,0,0,227,0,65,0,15,0,93,0,75,0,225,0,133,0,158,0,0,0,62,0,91,0,118,0,151,0,177,0,174,0,0,0,246,0,43,0,254,0,0,0,117,0,234,0,0,0,22,0,0,0,0,0,171,0,213,0,13,0,60,0,0,0,124,0);
signal scenario_full  : scenario_type := (0,0,94,31,94,30,94,29,83,31,177,31,53,31,235,31,235,30,227,31,227,30,104,31,20,31,73,31,73,30,68,31,213,31,191,31,50,31,158,31,194,31,34,31,189,31,123,31,222,31,222,30,172,31,26,31,167,31,132,31,246,31,108,31,175,31,218,31,180,31,144,31,124,31,124,30,82,31,18,31,152,31,71,31,125,31,22,31,7,31,90,31,90,30,246,31,246,30,34,31,60,31,196,31,241,31,165,31,105,31,134,31,125,31,125,30,56,31,174,31,125,31,230,31,230,30,179,31,151,31,160,31,44,31,151,31,6,31,6,30,37,31,250,31,250,30,26,31,113,31,113,30,109,31,228,31,190,31,114,31,16,31,189,31,216,31,216,30,110,31,202,31,202,30,124,31,227,31,165,31,20,31,136,31,202,31,179,31,251,31,251,30,251,29,251,28,14,31,255,31,128,31,180,31,47,31,172,31,172,30,172,29,212,31,160,31,160,30,136,31,144,31,211,31,211,30,41,31,82,31,171,31,171,30,171,29,158,31,149,31,35,31,35,30,142,31,89,31,117,31,10,31,135,31,204,31,93,31,103,31,194,31,121,31,62,31,70,31,201,31,78,31,146,31,77,31,45,31,249,31,44,31,85,31,228,31,213,31,240,31,104,31,104,30,191,31,47,31,247,31,164,31,164,30,164,29,90,31,130,31,130,30,16,31,205,31,106,31,106,30,33,31,104,31,139,31,139,30,62,31,62,30,105,31,202,31,50,31,208,31,208,30,55,31,18,31,184,31,2,31,2,30,240,31,216,31,216,30,230,31,32,31,157,31,236,31,224,31,254,31,51,31,29,31,204,31,202,31,78,31,234,31,244,31,170,31,8,31,8,30,235,31,77,31,226,31,38,31,33,31,151,31,161,31,161,30,104,31,243,31,241,31,222,31,22,31,22,30,182,31,184,31,182,31,236,31,236,31,189,31,113,31,168,31,174,31,155,31,155,30,99,31,36,31,191,31,55,31,65,31,68,31,68,30,220,31,166,31,208,31,113,31,34,31,151,31,83,31,97,31,250,31,116,31,32,31,16,31,76,31,76,30,71,31,42,31,36,31,254,31,43,31,43,30,40,31,10,31,22,31,22,30,181,31,115,31,98,31,100,31,147,31,160,31,135,31,135,30,212,31,236,31,254,31,20,31,103,31,168,31,159,31,159,30,229,31,219,31,153,31,92,31,92,30,56,31,59,31,24,31,248,31,27,31,179,31,31,31,233,31,233,30,232,31,71,31,71,30,167,31,126,31,236,31,184,31,184,30,211,31,119,31,27,31,205,31,205,30,205,29,70,31,254,31,188,31,100,31,251,31,89,31,195,31,186,31,8,31,45,31,239,31,92,31,245,31,79,31,190,31,190,30,131,31,227,31,107,31,107,30,197,31,8,31,8,30,82,31,41,31,1,31,70,31,141,31,171,31,227,31,124,31,233,31,4,31,160,31,165,31,165,30,165,29,158,31,185,31,3,31,183,31,124,31,94,31,217,31,132,31,132,30,132,29,74,31,203,31,69,31,228,31,161,31,65,31,51,31,2,31,51,31,89,31,180,31,75,31,200,31,198,31,81,31,81,30,227,31,65,31,15,31,93,31,75,31,225,31,133,31,158,31,158,30,62,31,91,31,118,31,151,31,177,31,174,31,174,30,246,31,43,31,254,31,254,30,117,31,234,31,234,30,22,31,22,30,22,29,171,31,213,31,13,31,60,31,60,30,124,31);

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
