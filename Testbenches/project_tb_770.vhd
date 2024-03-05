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

constant SCENARIO_LENGTH : integer := 392;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (130,0,246,0,168,0,118,0,42,0,144,0,94,0,63,0,62,0,94,0,239,0,12,0,70,0,0,0,0,0,84,0,178,0,40,0,81,0,243,0,0,0,0,0,168,0,106,0,13,0,0,0,169,0,26,0,184,0,142,0,210,0,164,0,250,0,0,0,69,0,161,0,62,0,252,0,60,0,214,0,134,0,238,0,190,0,103,0,75,0,82,0,245,0,105,0,103,0,1,0,45,0,0,0,100,0,251,0,209,0,184,0,0,0,25,0,0,0,248,0,88,0,181,0,159,0,39,0,0,0,64,0,0,0,143,0,211,0,113,0,0,0,41,0,0,0,188,0,0,0,0,0,187,0,0,0,0,0,67,0,0,0,0,0,0,0,66,0,235,0,224,0,0,0,31,0,0,0,253,0,164,0,147,0,232,0,72,0,0,0,226,0,190,0,128,0,0,0,134,0,66,0,151,0,69,0,7,0,0,0,211,0,0,0,94,0,0,0,137,0,2,0,101,0,0,0,143,0,197,0,0,0,115,0,40,0,0,0,0,0,0,0,0,0,213,0,91,0,204,0,115,0,0,0,163,0,0,0,100,0,6,0,33,0,202,0,189,0,170,0,137,0,225,0,28,0,39,0,4,0,59,0,162,0,56,0,0,0,154,0,0,0,235,0,134,0,29,0,2,0,0,0,139,0,59,0,186,0,191,0,0,0,230,0,0,0,10,0,214,0,208,0,0,0,205,0,236,0,0,0,23,0,193,0,0,0,175,0,0,0,253,0,0,0,157,0,0,0,0,0,248,0,192,0,0,0,142,0,145,0,174,0,69,0,81,0,0,0,155,0,180,0,232,0,162,0,9,0,148,0,146,0,233,0,108,0,0,0,180,0,209,0,135,0,132,0,144,0,143,0,170,0,80,0,0,0,238,0,49,0,0,0,230,0,200,0,75,0,22,0,0,0,233,0,201,0,205,0,119,0,36,0,130,0,133,0,232,0,170,0,5,0,0,0,28,0,0,0,89,0,0,0,0,0,0,0,146,0,38,0,253,0,190,0,191,0,166,0,240,0,186,0,39,0,24,0,171,0,127,0,0,0,218,0,157,0,0,0,0,0,21,0,201,0,105,0,16,0,76,0,0,0,31,0,0,0,46,0,56,0,71,0,55,0,174,0,196,0,11,0,127,0,119,0,0,0,0,0,40,0,199,0,62,0,65,0,220,0,0,0,73,0,58,0,195,0,102,0,39,0,0,0,14,0,115,0,165,0,0,0,45,0,255,0,0,0,0,0,85,0,227,0,225,0,0,0,73,0,68,0,112,0,217,0,93,0,0,0,124,0,204,0,129,0,143,0,75,0,0,0,228,0,255,0,177,0,227,0,101,0,125,0,253,0,144,0,223,0,206,0,11,0,67,0,228,0,211,0,222,0,0,0,57,0,190,0,100,0,0,0,30,0,193,0,190,0,0,0,21,0,0,0,0,0,135,0,45,0,27,0,0,0,54,0,0,0,0,0,0,0,0,0,68,0,157,0,155,0,0,0,0,0,0,0,0,0,227,0,84,0,147,0,235,0,185,0,37,0,0,0,0,0,66,0,0,0,97,0,234,0,242,0,59,0,245,0,94,0,255,0,217,0,44,0,0,0,187,0,153,0,150,0,0,0,248,0,54,0,45,0,82,0,53,0,0,0,213,0,245,0,99,0,0,0,2,0,213,0,125,0,233,0,0,0,153,0,245,0,165,0,184,0,2,0,0,0,72,0,0,0,173,0,202,0);
signal scenario_full  : scenario_type := (130,31,246,31,168,31,118,31,42,31,144,31,94,31,63,31,62,31,94,31,239,31,12,31,70,31,70,30,70,29,84,31,178,31,40,31,81,31,243,31,243,30,243,29,168,31,106,31,13,31,13,30,169,31,26,31,184,31,142,31,210,31,164,31,250,31,250,30,69,31,161,31,62,31,252,31,60,31,214,31,134,31,238,31,190,31,103,31,75,31,82,31,245,31,105,31,103,31,1,31,45,31,45,30,100,31,251,31,209,31,184,31,184,30,25,31,25,30,248,31,88,31,181,31,159,31,39,31,39,30,64,31,64,30,143,31,211,31,113,31,113,30,41,31,41,30,188,31,188,30,188,29,187,31,187,30,187,29,67,31,67,30,67,29,67,28,66,31,235,31,224,31,224,30,31,31,31,30,253,31,164,31,147,31,232,31,72,31,72,30,226,31,190,31,128,31,128,30,134,31,66,31,151,31,69,31,7,31,7,30,211,31,211,30,94,31,94,30,137,31,2,31,101,31,101,30,143,31,197,31,197,30,115,31,40,31,40,30,40,29,40,28,40,27,213,31,91,31,204,31,115,31,115,30,163,31,163,30,100,31,6,31,33,31,202,31,189,31,170,31,137,31,225,31,28,31,39,31,4,31,59,31,162,31,56,31,56,30,154,31,154,30,235,31,134,31,29,31,2,31,2,30,139,31,59,31,186,31,191,31,191,30,230,31,230,30,10,31,214,31,208,31,208,30,205,31,236,31,236,30,23,31,193,31,193,30,175,31,175,30,253,31,253,30,157,31,157,30,157,29,248,31,192,31,192,30,142,31,145,31,174,31,69,31,81,31,81,30,155,31,180,31,232,31,162,31,9,31,148,31,146,31,233,31,108,31,108,30,180,31,209,31,135,31,132,31,144,31,143,31,170,31,80,31,80,30,238,31,49,31,49,30,230,31,200,31,75,31,22,31,22,30,233,31,201,31,205,31,119,31,36,31,130,31,133,31,232,31,170,31,5,31,5,30,28,31,28,30,89,31,89,30,89,29,89,28,146,31,38,31,253,31,190,31,191,31,166,31,240,31,186,31,39,31,24,31,171,31,127,31,127,30,218,31,157,31,157,30,157,29,21,31,201,31,105,31,16,31,76,31,76,30,31,31,31,30,46,31,56,31,71,31,55,31,174,31,196,31,11,31,127,31,119,31,119,30,119,29,40,31,199,31,62,31,65,31,220,31,220,30,73,31,58,31,195,31,102,31,39,31,39,30,14,31,115,31,165,31,165,30,45,31,255,31,255,30,255,29,85,31,227,31,225,31,225,30,73,31,68,31,112,31,217,31,93,31,93,30,124,31,204,31,129,31,143,31,75,31,75,30,228,31,255,31,177,31,227,31,101,31,125,31,253,31,144,31,223,31,206,31,11,31,67,31,228,31,211,31,222,31,222,30,57,31,190,31,100,31,100,30,30,31,193,31,190,31,190,30,21,31,21,30,21,29,135,31,45,31,27,31,27,30,54,31,54,30,54,29,54,28,54,27,68,31,157,31,155,31,155,30,155,29,155,28,155,27,227,31,84,31,147,31,235,31,185,31,37,31,37,30,37,29,66,31,66,30,97,31,234,31,242,31,59,31,245,31,94,31,255,31,217,31,44,31,44,30,187,31,153,31,150,31,150,30,248,31,54,31,45,31,82,31,53,31,53,30,213,31,245,31,99,31,99,30,2,31,213,31,125,31,233,31,233,30,153,31,245,31,165,31,184,31,2,31,2,30,72,31,72,30,173,31,202,31);

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
